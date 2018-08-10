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
    
    func loginInSystem(email: String, password: String, switchRemember: Bool) -> Bool {
        guard email.count >= 6 && password.count >= 6 else {
            print ("Email or Password so short")
//            signIn.isEnabled = true
            return false
        }
        Auth.auth().signIn(withEmail: email, password: password) { _, error in
            if let error = error {
                print("Sign In error:", error)
//                self.signIn.isEnabled = true
                return
            }
//            self.signIn.isEnabled = true
            print("Sign In success")
            if switchRemember {
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
//        self.performSegue(withIdentifier: "MainViewSeque", sender: self)
        }
        return true
    }
}
