//
//  MainView.swift
//  VoteOnOffice
//
//  Created by Admin on 27.06.2018.
//  Copyright © 2018 Heads and Hands. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class MainView: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    
    var items: [DataVoteCell] = []
    let abc:ReadDataBase = ReadDataBase()
    var selectRow:String!
    var adminStatus = false
    
    @IBOutlet weak var btnAdd: UIButton!
    @IBAction func SignOut(_ sender: Any) {
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
        self.readDataBase()
        if adminStatus == false { btnAdd.isHidden = true }
        else {btnAdd.isHidden = false}
        //self.tableView.register(MyCell.self, forCellReuseIdentifier: "cell")
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func readDataBase()->Void{
        let db = Firestore.firestore()
        db.collection("Votes").getDocuments{(snapshot,error) in
            if error != nil {print(error as Any)}
            else{
                for documents in (snapshot?.documents)!{
                    var dtc = DataVoteCell()
                    dtc.title = (documents.data()["voteTitle"]as?String)!
                    //dtc.status = (documents.data()["voteStatus"]as?Bool)!
                    dtc.time = (documents.data()["voteDate"]as?String)!
                    dtc.UUID = (documents.data()["voteUUID"]as?String)!
                    db.collection("Users").whereField("userEmail", isEqualTo: Auth.auth().currentUser?.email).getDocuments{(snapshot,error) in
                        if error != nil {print(error as Any)}
                        else{
                            for documents in (snapshot?.documents)!{
                                self.adminStatus = (documents.data()["userRole"] as? Bool)!
                                let arrays:[[String:Any]] = (documents.data()["userVotesList"] as? [[String : Any]])!
                                let even = arrays.filter { $0["voteUUID"] as? String == dtc.UUID}
                                if even.count > 0 {dtc.status = true}
                                self.items.append(dtc)
                                self.tableView.reloadData()
                                if self.adminStatus == false { self.btnAdd.isHidden = true }
                                else {self.btnAdd.isHidden = false}
                            }
                            
                        }
                        
                    }
                    
                    self.tableView.reloadData()
                }
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
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell:MyCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! MyCell
        if (items[indexPath.row].status == false){
            cell.statusCell?.text = "X"
            cell.statusCell?.textColor = UIColor.red
        }else{
            cell.statusCell?.text = "V"
            cell.statusCell?.textColor = UIColor.green
        }
        cell.timeCell?.text = items[indexPath.row].time
        cell.titleCell?.text = items[indexPath.row].title
        //cell.titleCell?.text=self.items[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle:   UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if adminStatus == true {
            if (editingStyle == .delete) {
                let db = Firestore.firestore()
                db.collection("Votes").document(items[indexPath.row].UUID).delete() { err in
                    if let err = err {
                        print("Error removing document: \(err)")
                    } else {
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
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectRow = self.items[indexPath.row].UUID
        performSegue(withIdentifier: "VoteView", sender: self)
        print(selectRow)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let ViewController = segue.destination as? VoteView {
            ViewController.UUID = selectRow
        }
    }
    
    
}
