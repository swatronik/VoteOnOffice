//
//  AddVoteView.swift
//  VoteOnOffice
//
//  Created by Admin on 03.07.2018.
//  Copyright © 2018 Heads and Hands. All rights reserved.
//

import UIKit
import FirebaseFirestore

class AddVoteView: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var descriptionLabel: UITextView!
    @IBOutlet weak var tableViewApp: UITableView!
    @IBOutlet weak var titleLabel: UITextField!
    var tre:[Int]=[]
    var uuid = UUID.init().uuidString
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.tableViewApp.register(AddVoteCell.self, forCellReuseIdentifier: "voteCell")
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func AddNewVarible(_ sender: Any) {
        tre.append(tre.count+1)
        tableViewApp.reloadData()
    }
    
    func nowTime()->String{
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MMM/yyyy hh:mm:ss"
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
    func variantsArray()->Array<[String: Any]>{
        var ind = tre.count - 1
        for _ in tre{
            tre[ind] = ind + 1
            ind = ind - 1
        }
        var array:[[String:Any]]=[]
        for index in tre{
            let indx = IndexPath(row: index-1, section: 0)
            let variants : [String: Any] = [
                "variantId" : tre[index-1],
                "variantImgURL" : "",
                "variantName" : ((tableViewApp.cellForRow(at: indx)) as! AddVoteCell).textVoteCell.text,
                "variantVoteStatus" : 0
            ]
            array.append(variants);
        }
        return array
    }
    
    @IBAction func AddNewVote(_ sender: Any) {
        let db = Firestore.firestore()
        let docData: [String: Any] = [
            "voteDate" : nowTime(),
            "voteDescription" : descriptionLabel.text,
            "voteStatus" : false,
            "voteTitle" : titleLabel.text,
            "voteUUID" : uuid,
            "voteVariants" : variantsArray()
        ]
        db.collection("Votes").document(uuid).setData(docData) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
        performSegue(withIdentifier: "ReturnOnMainView", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableViewApp: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tre.count//self.items.count
    }
    
    public func tableView(_ tableViewApp: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell:AddVoteCell = tableViewApp.dequeueReusableCell(withIdentifier: "voteCell", for: indexPath) as! AddVoteCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle:   UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            tre.remove(at: indexPath.row)
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .middle)
            tableView.endUpdates()
        }
    }

    
    func tableView(_ tableViewApp: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You selected cell #\(indexPath.row)!")
    }
    
    
}
