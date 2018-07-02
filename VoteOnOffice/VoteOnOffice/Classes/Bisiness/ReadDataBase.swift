//
//  ReadDataBase.swift
//  VoteOnOffice
//
//  Created by Admin on 28.06.2018.
//  Copyright © 2018 Heads and Hands. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class ReadDataBase{

    
    func readDataBase()->Void{
        let db = Firestore.firestore()
        db.collection("Votes").getDocuments{(snapshot,error) in
            if error != nil {print(error)}
            else{
                for documents in (snapshot?.documents)!{
                    let value: String = (documents.data()["voteTitle"]as?String)!
                    //self.items.append(value)
                    print(value)
                    //self.upload()
                }
            }
        }
        print((Auth.auth().currentUser?.email)!)
    }
    
    
}

