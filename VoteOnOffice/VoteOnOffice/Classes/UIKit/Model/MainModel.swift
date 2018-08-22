//
//  MainModel.swift
//  VoteOnOffice
//
//  Created by New on 22.08.2018.
//  Copyright © 2018 Heads and Hands. All rights reserved.
//

import RealmSwift
import FirebaseFirestore


class MainModel {
    
    func deleteRealmData(){
        guard let realm = try? Realm() else {
            return
        }
        try? realm.write {
            let result = realm.objects(RememberData.self)
            realm.delete(result)
        }
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
    
    
    
}
