//
//  MyCell.swift
//  VoteOnOffice
//
//  Created by Admin on 29.06.2018.
//  Copyright © 2018 Heads and Hands. All rights reserved.
//

import UIKit

class MyCell: UITableViewCell {

    @IBOutlet private weak var titleCell: UILabel!
    @IBOutlet private weak var timeCell: UILabel!
    @IBOutlet private weak var statusCell: UILabel!

    func titleSet(value: String) {
        titleCell.text = value
    }

    func timeSet(value: String) {
        timeCell.text = value
    }

    func statusSet(value: String, color: UIColor) {
        statusCell.text = value
        statusCell.textColor = color
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
