//
//  VoteCell.swift
//  VoteOnOffice
//
//  Created by Admin on 09.07.2018.
//  Copyright © 2018 Heads and Hands. All rights reserved.
//

import UIKit

class VoteCell: UITableViewCell {
    
    @IBOutlet weak var title:UILabel!
    @IBOutlet weak var procent: UILabel!
    
    var status:Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
