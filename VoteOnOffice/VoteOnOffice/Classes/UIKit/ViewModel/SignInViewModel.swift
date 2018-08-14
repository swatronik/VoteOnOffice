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
                signInModel.writeData(email: email, password: password)
            }
//        self.performSegue(withIdentifier: "MainViewSeque", sender: self)
        }
        if Auth.auth().currentUser?.email == nil {
            return false
        } else {
            return true
        }
    }
    
    func oldDataLoading() -> Bool {
        let logining: RememberData = signInModel.readData()
        self.loginInSystem(email: logining.login, password: logining.password, switchRemember: false)
        if Auth.auth().currentUser?.email == nil {
            return false
        } else {
            return true
        }
    }
    
}
