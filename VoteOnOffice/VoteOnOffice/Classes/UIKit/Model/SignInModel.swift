//
//  SignInModel.swift
//  VoteOnOffice
//
//  Created by New on 10.08.2018.
//  Copyright © 2018 Heads and Hands. All rights reserved.
//
import FirebaseAuth
import RealmSwift

class SignInModel {
    
    func writeData(email: String, password: String) {
        let thisLogin = RememberData()
        guard let realm = try? Realm() else {
            return
        }
        try? realm.write {
            thisLogin.login = email
            thisLogin.password = password
            realm.add(thisLogin)
        }
    }
    
    func readData() -> RememberData? {
        guard let realm = try? Realm() else {
            return nil
        }
        let results = realm.objects(RememberData.self)
        guard let logining = results.first else {
            return nil
        }
        return logining
    }
    
}
