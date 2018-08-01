//
//  MainView.swift
//  VoteOnOffice
//
//  Created by Admin on 27.06.2018.
//  Copyright © 2018 Heads and Hands. All rights reserved.
//

import FirebaseAuth
import FirebaseFirestore
import RealmSwift
import UIKit

struct DataVoteCell {
    var title = ""
    var time = ""
    var status = false
    var UUID = ""
}

class MainView: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet private weak var btnAdd: UIButton!
    @IBOutlet private weak var tableView: UITableView!

    var items: [DataVoteCell] = []
    var selectRow: String!
    var adminStatus = false
    let emailString: String! = Auth.auth().currentUser?.email

    @IBAction private func signOut(_ sender: Any) {
        guard let realm = try? Realm() else {
            return
        }
        try? realm.write {
            let result = realm.objects(RememberData.self)
            realm.delete(result)
        }
        let firebaseAuth = Auth.auth()
        do {
            try
                firebaseAuth.signOut()
                performSegue(withIdentifier: "ReturnOnFirstView", sender: self)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        self.readDataBase()
        if adminStatus == false { btnAdd.isHidden = true
        } else {
            btnAdd.isHidden = false
        }
        //self.tableView.register(MyCell.self, forCellReuseIdentifier: "cell")
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        items.removeAll()
        tableView.reloadData()
    }

    func dataVoteInit(documents: QueryDocumentSnapshot) -> DataVoteCell {
        var dvc = DataVoteCell()
        guard let dvcTitle: String = documents.data()["voteTitle"]as?String else {
            return dvc
        }
        dvc.title = dvcTitle
        guard let dvcTime: String = documents.data()["voteDate"]as?String else {
            return dvc
        }
        dvc.time = dvcTime
        guard let dvcUUID: String = documents.data()["voteUUID"]as?String else {
            return dvc
        }
        dvc.UUID = dvcUUID
        return dvc
    }

    func readDataBase() {
        let databaseFirestore = Firestore.firestore()
        databaseFirestore.collection("Votes").getDocuments { snapshot, error in
            guard error == nil else {
                print(error as Any)
                return
            }
            guard let requestSnapshot = snapshot?.documents else {
                fatalError("request snapshot Error")
            }
            for documents in requestSnapshot {
                var dtc: DataVoteCell = self.dataVoteInit(documents: documents)
                let request = databaseFirestore.collection("Users").whereField("userEmail", isEqualTo: self.emailString)
                request.getDocuments { snapshot, error in
                    guard error == nil else {
                        print(error ?? Error.self)
                        return
                    }
                    guard let requestSnapshot = snapshot?.documents else {
                        fatalError("request snapshot Error")
                    }
                    for documents in requestSnapshot {
                        guard let status: Bool = documents.data()["userRole"] as? Bool else {
                            fatalError("Error admin status")
                        }
                        self.adminStatus = status
                        guard let arrays: [[String: Any]] = documents.data()["userVotesList"] as?[[String: Any]] else {
                            fatalError("Error convert array")
                        }
                        let even = arrays.filter {
                            $0["voteUUID"] as? String == dtc.UUID
                        }
                        if !even.isEmpty {
                            dtc.status = true
                        }
                        self.items.append(dtc)
                        self.tableView.reloadData()
                        if self.adminStatus == false {
                            self.btnAdd.isHidden = true
                        } else {
                            self.btnAdd.isHidden = false
                        }
                    }
                }
                self.tableView.reloadData()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: MyCell = tableView.dequeueReusableCell(withIdentifier: "cell") as? MyCell else {
            fatalError("Error Cell convert")
        }
        if !items[indexPath.row].status {
            cell.statusSet(value: "X", color: UIColor.red)
        } else {
            cell.statusSet(value: "V", color: UIColor.green)
        }
        cell.timeSet(value: items[indexPath.row].time)
        cell.titleSet(value: items[indexPath.row].title)
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if adminStatus == true {
            if editingStyle == .delete {
                let databaseFirestore = Firestore.firestore()
                databaseFirestore.collection("Votes").document(items[indexPath.row].UUID).delete { error in
                    guard error == nil else {
                        print (error ?? Error.self)
                        return
                    }
                    print("Document successfully removed!")
                    print(self.items[indexPath.row].UUID)
                    self.items.remove(at: indexPath.row)
                    tableView.beginUpdates()
                    tableView.deleteRows(at: [indexPath], with: .middle)
                    tableView.endUpdates()
                }
            }
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectRow = self.items[indexPath.row].UUID
        performSegue(withIdentifier: "VoteView", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? VoteView {
            viewController.UUID = selectRow
        }
    }
}
