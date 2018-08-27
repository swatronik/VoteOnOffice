//
//  FirstView.swift
//  VoteApp
//
//  Created by Admin on 26.06.2018.
//  Copyright © 2018 Heads and Hands. All rights reserved.
//

import UIKit

class FirstView: UIViewController {
    
    @IBOutlet private weak var signIn: UIButton!
    @IBOutlet private weak var signUp: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        signIn.layer.cornerRadius = signIn.frame.size.height/2
        signUp.layer.cornerRadius = signUp.frame.size.height/2
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
