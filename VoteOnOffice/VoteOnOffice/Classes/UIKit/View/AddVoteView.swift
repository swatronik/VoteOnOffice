//
//  AddVoteView.swift
//  VoteOnOffice
//
//  Created by Admin on 03.07.2018.
//  Copyright © 2018 Heads and Hands. All rights reserved.
//

import FirebaseFirestore
import UIKit

class AddVoteView: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet private weak var cancelButton: UIButton!
    @IBOutlet private weak var descriptionLabel: UITextView!
    @IBOutlet private weak var tableViewApp: UITableView!
    @IBOutlet private weak var titleLabel: UITextField!

    var tre: [Int] = []
    var uuid = UUID().uuidString

    override func viewDidLoad() {
        super.viewDidLoad()
        //self.tableViewApp.register(AddVoteCell.self, forCellReuseIdentifier: "voteCell")
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction private func addNewVarible(_ sender: Any) {
        tre.append(tre.count + 1)
        tableViewApp.reloadData()
    }

    func nowTime() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MMM/yyyy hh:mm:ss"
        let dateString = dateFormatter.string(from: date)
        return dateString
    }

    func variantsArray() -> [[String: Any]] {
        var ind = tre.count - 1
        for _ in tre {
            tre[ind] = ind + 1
            ind -= 1
        }
        var array: [[String: Any]] = []
        for index in tre {
            let indx = IndexPath(row: index - 1, section: 0)
            guard let cell: AddVoteCell = (tableViewApp.cellForRow(at: indx) as? AddVoteCell) else {
                fatalError("Error Cell convert")
            }
            let variants: [String: Any] = [
                "variantId": tre[index - 1],
                "variantImgURL": "",
                "variantName": cell.getText(),
                "variantVoteStatus": 0
            ]
            array.append(variants)
        }
        return array
    }

    @IBAction private func addNewVote(_ sender: Any) {
        let databaseFirestore = Firestore.firestore()
        guard let voteTitle: String = titleLabel.text else {
            print ("Title is not fill")
            return
        }
        let docData: [String: Any] = [
            "voteDate": nowTime(),
            "voteDescription": descriptionLabel.text,
            "voteStatus": false,
            "voteTitle": voteTitle,
            "voteUUID": uuid,
            "voteVariants": variantsArray()
        ]
        databaseFirestore.collection("Votes").document(uuid).setData(docData) { error in
            guard error == nil else {
                print(error ?? Error.self)
                return
            }
        }
        performSegue(withIdentifier: "ReturnOnMainView", sender: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(_ tableViewApp: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tre.count
    }

    public func tableView(_ tableViewApp: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: AddVoteCell = (tableViewApp.dequeueReusableCell(withIdentifier: "voteCell") as? AddVoteCell) else {
            fatalError("Error Cell convert")
        }
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tre.remove(at: indexPath.row)
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .middle)
            tableView.endUpdates()
        }
    }

    func tableView(_ tableViewApp: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}
