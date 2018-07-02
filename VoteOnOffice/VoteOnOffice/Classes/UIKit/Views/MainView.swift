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
    override func viewDidLoad() {
        self.readDataBase()
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
                    dtc.status = (documents.data()["voteStatus"]as?Bool)!
                    dtc.time = (documents.data()["voteDate"]as?String)!
                    self.items.append(dtc)
                    print(dtc)
                    self.upload()
                }
            }
        }
        print((Auth.auth().currentUser?.email)!)
    }
    
    func upload(){
        self.tableView.reloadData()
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

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You selected cell #\(indexPath.row)!")
    }
    
    
    
    
}
