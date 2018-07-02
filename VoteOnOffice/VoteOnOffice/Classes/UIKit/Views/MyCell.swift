//
//  MyCell.swift
//  VoteOnOffice
//
//  Created by Admin on 29.06.2018.
//  Copyright © 2018 Heads and Hands. All rights reserved.
//

import UIKit

class MyCell: UITableViewCell {
    
    @IBOutlet weak var titleCell:UILabel!
    @IBOutlet weak var timeCell: UILabel!
    @IBOutlet weak var statusCell: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
