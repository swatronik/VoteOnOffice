//
//  SignUpViewModel.swift
//  VoteOnOffice
//
//  Created by New on 22.08.2018.
//  Copyright © 2018 Heads and Hands. All rights reserved.
//
import FirebaseAuth
import FirebaseFirestore
import RealmSwift
import RxSwift

class SignUpViewModel {
    
    var loginIsBool = PublishSubject<Bool>()
    private var signModel: SignModel = SignModel()
    
    func loginInSistem(email: String, password: String, switchRemember: Bool) {
        guard email.count >= 6 && password.count >= 6 else {
            print ("Email or Password so short")
            loginIsBool.onNext(false)
            return
        }
        Auth.auth().createUser(withEmail: email, password: password) { _, error in
            guard error == nil else {
                print("Sign In error:", error as Any)
                self.loginIsBool.onNext(false)
                return
            }
            let databaseFirestore = Firestore.firestore()
            let docData: [String: Any] = [
                "userEmail": email,
                "userRole": false,
                "userVotesList": [[String: Any]]()
            ]
            databaseFirestore.collection("Users").document(email).setData(docData) { err in
                guard err == nil else {
                    print("Sign In error:", err as Any)
                    self.loginIsBool.onNext(false)
                    return
                }
                self.loginIsBool.onNext(true)
                print("Sign Up Success")
            }
            if switchRemember {
                self.signModel.writeData(email: email, password: password)
            }
        }
    }
}
