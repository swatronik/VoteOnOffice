//
//  SignInViewModel.swift
//  VoteOnOffice
//
//  Created by New on 10.08.2018.
//  Copyright © 2018 Heads and Hands. All rights reserved.
//
import FirebaseAuth
import RealmSwift
import RxSwift

class SignInViewModel {

    var loginIsBool = PublishSubject<Bool>()
    private var signInModel: SignInModel = SignInModel()
    
    func loginInSistem(email: String, password: String, switchRemember: Bool) {
        guard email.count >= 6 && password.count >= 6 else {
            print ("Email or Password so short")
            loginIsBool.onNext(false)
            return
        }
        Auth.auth().signIn(withEmail: email, password: password) { _, error in
            if let error = error {
                print("Sign In error:", error)
                self.loginIsBool.onNext(false)
                return
            }
            self.loginIsBool.onNext(true)
            print("Sign In success")
            if switchRemember {
                self.signInModel.writeData(email: email, password: password)
            }
        }
    }
    
    func oldDataLoading() {
        let logining: RememberData? = signInModel.readData()
        guard let loginData = logining else {
            loginIsBool.onNext(false)
            return
        }
        self.loginInSistem(email: loginData.login, password: loginData.password, switchRemember: false)
    }
    
}
