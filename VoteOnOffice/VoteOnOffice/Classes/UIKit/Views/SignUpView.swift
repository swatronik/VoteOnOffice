//
//  SignUpView.swift
//  VoteApp
//
//  Created by Admin on 26.06.2018.
//  Copyright © 2018 Heads and Hands. All rights reserved.
//

import FirebaseAuth
import FirebaseFirestore
import UIKit

class SignUpView: UIViewController {

    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var rememberMeSwitch: UISwitch!
    @IBOutlet private weak var signUp: UIButton!

    @IBAction private func signUp(_ sender: Any) {
        signUp.isEnabled = false
        let emailString: String! = emailTextField.text
        let passwordString: String! = passwordTextField.text
        guard emailString.count >= 6 && passwordString.count >= 6 else {
            print ("Email or Password so short")
            signUp.isEnabled = true
            return
        }
        Auth.auth().createUser(withEmail: emailString, password: passwordString) { _, error in
            guard error == nil else {
                print (error ?? Error.self)
                self.signUp.isEnabled = true
                return
            }
            let databaseFirestore = Firestore.firestore()
            let docData: [String: Any] = [
                "userEmail": emailString,
                "userRole": false,
                "userVotesList": [[String: Any]]()
            ]
            databaseFirestore.collection("Users").document(emailString).setData(docData) { err in
                guard err == nil else {
                    print("Sign Up Error: \(String(describing: err))")
                    self.signUp.isEnabled = true
                    return
                }
                self.signUp.isEnabled = true
                print("Sign Up Success")
            }
            self.performSegue(withIdentifier: "MainViewSeque", sender: self)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
