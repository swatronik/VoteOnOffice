//
//  SignUpView.swift
//  VoteApp
//
//  Created by Admin on 26.06.2018.
//  Copyright © 2018 Heads and Hands. All rights reserved.
//

import RxSwift
import RxCocoa
import UIKit

class SignUpView: UIViewController {

    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var rememberMeSwitch: UISwitch!
    @IBOutlet private weak var signUp: UIButton!
    
    let signUpViewModel: SignUpViewModel = SignUpViewModel()
    let disposeBag = DisposeBag()
    var login = Variable<Bool>(false)
    
    @IBAction private func signUp(_ sender: Any) {
        signUp.isEnabled = false
        signUpViewModel.loginInSistem(email: emailTextField.text!, password: passwordTextField.text!, switchRemember: rememberMeSwitch.isOn)
        signUp.isEnabled = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        login.asObservable().subscribe() { _ in
            if self.login.value {
                self.performSegue(withIdentifier: "MainViewSeque", sender: self)
            }
        }.disposed(by: disposeBag)
        signUpViewModel.loginIsBool.asObservable().bind(to: login).disposed(by: disposeBag)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
