//
//  SignModel.swift
//  VoteOnOffice
//
//  Created by New on 10.08.2018.
//  Copyright © 2018 Heads and Hands. All rights reserved.
//

import RealmSwift
import UIKit

class RememberData: Object {
    @objc dynamic var login = ""
    @objc dynamic var password = ""
    
    override class func primaryKey() -> String? {
        return "login"
    }
}
