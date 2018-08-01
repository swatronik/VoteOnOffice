//
//  SignInView.swift
//  VoteApp
//
//  Created by Admin on 26.06.2018.
//  Copyright © 2018 Heads and Hands. All rights reserved.
//

import FirebaseAuth
import UIKit

class SignInView: UIViewController {

    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var remeberMeSwitch: UISwitch!
    @IBOutlet private weak var signIn: UIButton!

    @IBAction private func signIn(_ sender: Any) {
        signIn.isEnabled = false
        let emailString: String! = emailTextField.text
        let passwordString: String! = passwordTextField.text
        guard emailString.count >= 6 && passwordString.count >= 6 else {
            print ("Email or Password so short")
            signIn.isEnabled = true
            return
        }
        Auth.auth().signIn(withEmail: emailString, password: passwordString) { _, error in
            if let error = error {
                print("Sign In error:", error)
                self.signIn.isEnabled = true
                return
            }
            self.signIn.isEnabled = true
            print("Sign In success")
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
