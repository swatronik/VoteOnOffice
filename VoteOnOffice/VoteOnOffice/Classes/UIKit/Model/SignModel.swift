//
//  SignModel.swift
//  VoteOnOffice
//
//  Created by New on 10.08.2018.
//  Copyright © 2018 Heads and Hands. All rights reserved.
//

import RealmSwift
import UIKit

class RememberData: Object {
    @objc dynamic var login = ""
    @objc dynamic var password = ""
    
    override class func primaryKey() -> String? {
        return "login"
    }
}

class SignModel {
    
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
