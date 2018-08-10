//
//  SignInViewModel.swift
//  VoteOnOffice
//
//  Created by New on 10.08.2018.
//  Copyright © 2018 Heads and Hands. All rights reserved.
//

import FirebaseAuth
import RealmSwift

class SignInViewModel {
    
    private var signInModel: SignInModel = SignInModel()
    
    func loginInSistem(email: String, password: String, switchRemember: Bool) -> Bool {
        guard let login: Bool = signInModel.loginInSystem(email: email, password: password, switchRemember: switchRemember) else {
            return false
        }
        if !login {
            return false
        } else if Auth.auth().currentUser?.email == nil {
                return false
            } else {
                return true
            }
    }
    
    func oldDataLoading() -> Bool {
        guard let realm = try? Realm() else {
            return false
        }
        let results = realm.objects(RememberData.self)
        guard let logining = results.first else {
            return false
        }
        guard let login: Bool = signInModel.loginInSystem(email: logining.login, password: logining.password, switchRemember: false) else {
            return false
        }
        if !login {
            return false
        } else if Auth.auth().currentUser?.email == nil {
                return false
            } else {
                return true
            }
    }
    
}
