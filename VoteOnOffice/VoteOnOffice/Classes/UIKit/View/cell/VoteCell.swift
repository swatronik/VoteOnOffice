//
//  VoteCell.swift
//  VoteOnOffice
//
//  Created by Admin on 09.07.2018.
//  Copyright © 2018 Heads and Hands. All rights reserved.
//

import UIKit

struct DataVoteCell {
    var title = ""
    var time = ""
    var status = false
    var UUID = ""
}

class VoteCell: UITableViewCell {
    @IBOutlet private weak var title: UILabel!
    var status: Int = 0
    func titleSet(value: String) {
        title.text = value
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
