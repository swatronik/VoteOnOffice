//
//  AddVoteModel.swift
//  VoteOnOffice
//
//  Created by New on 22.08.2018.
//  Copyright © 2018 Heads and Hands. All rights reserved.
//

import Foundation

class AddVoteModel {
    
    func nowTime() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MMM/yyyy hh:mm:ss"
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
    
    
    
}
