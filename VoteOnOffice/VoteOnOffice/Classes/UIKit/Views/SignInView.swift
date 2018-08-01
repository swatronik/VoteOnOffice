//
//  SignInView.swift
//  VoteApp
//
//  Created by Admin on 26.06.2018.
//  Copyright © 2018 Heads and Hands. All rights reserved.
//

import FirebaseAuth
import RealmSwift
import UIKit

class RememberData: Object {
    @objc dynamic var login = ""
    @objc dynamic var password = ""

    override class func primaryKey() -> String? {
        return "login"
    }
}

class SignInView: UIViewController {

    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var rememberMeSwitch: UISwitch!
    @IBOutlet private weak var signIn: UIButton!

    @IBAction private func signIn(_ sender: Any) {
        loginInSistem()
    }

    func loginInSistem() {
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
            if self.rememberMeSwitch.isOn {
                let thisLogin = RememberData()
                guard let realm = try? Realm() else {
                    return
                }
                try? realm.write {
                    thisLogin.login = emailString
                    thisLogin.password = passwordString
                    realm.add(thisLogin)
                }
            }
            self.performSegue(withIdentifier: "MainViewSeque", sender: self)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let realm = try? Realm() else {
            return
        }
        let results = realm.objects(RememberData.self)
        guard let logining = results.first else {
            return
        }
        emailTextField.text = logining.login
        passwordTextField.text = logining.password
        loginInSistem()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
