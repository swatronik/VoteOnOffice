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


class SignInView: UIViewController {

    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var rememberMeSwitch: UISwitch!
    @IBOutlet private weak var signIn: UIButton!
    
    let signInViewModel: SignInViewModel = SignInViewModel()
    
    @IBAction private func signIn(_ sender: Any) {
        signIn.isEnabled = false
        if signInViewModel.loginInSistem(email: emailTextField.text!, password: passwordTextField.text!, switchRemember: rememberMeSwitch.isOn) {
            self.performSegue(withIdentifier: "MainViewSeque", sender: self)
        }
        signIn.isEnabled = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if signInViewModel.oldDataLoading() {
            self.performSegue(withIdentifier: "MainViewSeque", sender: self)
        }
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
