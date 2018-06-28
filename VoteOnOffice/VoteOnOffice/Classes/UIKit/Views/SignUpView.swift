//
//  SignUpView.swift
//  VoteApp
//
//  Created by Admin on 26.06.2018.
//  Copyright © 2018 Heads and Hands. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignUpView: UIViewController {
    
    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var Password: UITextField!
    @IBOutlet weak var RememberMe: UISwitch!
    
    @IBOutlet weak var signUp: UIButton!
    @IBAction func SignUp(_ sender: Any) {
        Auth.auth().createUser(withEmail: Email.text!, password: Password.text!) { (user, error) in
            if error == nil {
                print("success")
                self.performSegue(withIdentifier: "MainViewSeque", sender: self)
            }else{
                print("error",error!)
            }
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
