//
//  AddVoteCell.swift
//  VoteOnOffice
//
//  Created by Admin on 03.07.2018.
//  Copyright © 2018 Heads and Hands. All rights reserved.
//

import UIKit

class AddVoteCell: UITableViewCell {
    @IBOutlet private weak var textVoteCell: UITextView!
    func getText() -> String {
        return textVoteCell.text
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
