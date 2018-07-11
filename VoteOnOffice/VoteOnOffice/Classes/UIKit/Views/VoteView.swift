//
//  VoteView.swift
//  VoteOnOffice
//
//  Created by Admin on 09.07.2018.
//  Copyright © 2018 Heads and Hands. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class VoteView: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UITextView!
    var UUID: String!
    var arr: [[String:Any]] = []
    var selectRow: Int = -1
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let db = Firestore.firestore()
        db.collection("Votes").whereField("voteUUID", isEqualTo: UUID).getDocuments{(snapshot,error) in
            if error != nil {print(error as Any)}
            else{
                for documents in (snapshot?.documents)!{
                    db.collection("Users").whereField("userEmail", isEqualTo: Auth.auth().currentUser?.email).getDocuments{(snapshot,error) in
                        if error != nil {print(error as Any)}
                        else{
                            for documents in (snapshot?.documents)!{
                                let arrays:[[String:Any]] = (documents.data()["userVotesList"] as? [[String : Any]])!
                                let even = arrays.filter { $0["voteUUID"] as? String == self.UUID}
                                if even.count > 0 { self.selectRow = even.first!["voteVariantID"]! as! Int }
                                self.tableView.reloadData()
                            }
                            
                        }
                        
                    }
                    self.titleLabel?.text = documents.data()["voteTitle"]as?String
                    self.descriptionLabel?.text = documents.data()["voteDescription"]as?String
                    self.arr = (documents.data()["voteVariants"]as?[[String:Any]])!
                    self.tableView.reloadData()
                }
            }
        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arr.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell:VoteCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! VoteCell
        
        cell.title?.text = arr[indexPath.row]["variantName"] as? String
        //if allVote != 0 {
        cell.procent?.text = String(arr[indexPath.row]["variantVoteStatus"] as! Int)///allVote)
        //} else {cell.procent.text = "0"}
        if indexPath.row == selectRow {cell.backgroundColor = UIColor.green }
        else {cell.backgroundColor = UIColor.white}
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let db = Firestore.firestore()
        var array: [[String:Any]] = []
        db.collection("Users").whereField("userEmail", isEqualTo: Auth.auth().currentUser?.email).getDocuments{(snapshot,error) in
            if error != nil {print(error as Any)}
            else{
                for documents in (snapshot?.documents)!{
                    var arrays:[[String:Any]] = (documents.data()["userVotesList"] as? [[String : Any]])!
                    let even = arrays.filter { $0["voteUUID"] as? String == self.UUID }
                    if (even.count == 0){
                        arrays.append(["voteUUID": self.UUID, "voteVariantID":indexPath.row])
                        db.collection("Users").document((Auth.auth().currentUser?.email!)!).updateData(["userVotesList":arrays])
                        self.viewWillAppear(true)
                        db.collection("Votes").whereField("voteUUID", isEqualTo: self.UUID).getDocuments{(snapshot,error) in
                            if error != nil {print(error as Any)}
                            else{
                                for documents in (snapshot?.documents)!{
                                    array = (documents.data()["voteVariants"]as?[[String:Any]])!
                                    array[indexPath.row]["variantVoteStatus"] = array[indexPath.row]["variantVoteStatus"] as! Int + 1
                                    db.collection("Votes").document(self.UUID).updateData(["voteVariants" : array])
                                    print(array[indexPath.row]["variantVoteStatus"])
                                    self.viewWillAppear(true)
                                }
                            }
                        }
                        self.viewWillAppear(true)
                    }else{
                        var ind: Int = (even.first?["voteVariantID"] as? Int)!
                        var array: [[String:Any]] = []
                        db.collection("Votes").whereField("voteUUID", isEqualTo: self.UUID).getDocuments{(snapshot,error) in
                            if error != nil {print(error as Any)}
                            else{
                                for documents in (snapshot?.documents)!{
                                    array = (documents.data()["voteVariants"]as?[[String:Any]])!
                                    print(array[ind]["variantVoteStatus"])
                                    array[ind]["variantVoteStatus"] = array[ind]["variantVoteStatus"] as! Int - 1
                                    array[indexPath.row]["variantVoteStatus"] = array[indexPath.row]["variantVoteStatus"] as! Int + 1
                                    print(array)
                                    var even = arrays.filter { $0["voteUUID"] as! String != self.UUID }
                                    even.append(["voteUUID": self.UUID, "voteVariantID":indexPath.row])
                                    db.collection("Votes").document(self.UUID).updateData(["voteVariants" : array])
                                    db.collection("Users").document((Auth.auth().currentUser?.email!)!).updateData(["userVotesList":even])
                                }
                                self.viewWillAppear(true)
                            }
                        }
                        self.viewWillAppear(true)
                    }
                }
            }

            
        }
        

            
        print("You selected cell #\(indexPath.row)!")
    }
    
    
}
