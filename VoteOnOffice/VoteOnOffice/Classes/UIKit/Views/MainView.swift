//
//  MainView.swift
//  VoteOnOffice
//
//  Created by Admin on 27.06.2018.
//  Copyright © 2018 Heads and Hands. All rights reserved.
//

import UIKit
import FirebaseAuth

class MainView: UIViewController {
    
    @IBAction func SignOut(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try
                firebaseAuth.signOut()
                performSegue(withIdentifier: "ReturnOnFirstView", sender: self)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
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
