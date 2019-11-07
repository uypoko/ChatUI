//
//  ListMessageCell.swift
//  ChatUI
//
//  Created by Ryan on 11/6/19.
//  Copyright © 2019 Daylighter. All rights reserved.
//

import UIKit

class ListMessageCell: UITableViewCell {

    @IBOutlet weak var senderImageView: UIImageView!
    @IBOutlet weak var senderNameLabel: UILabel!
    @IBOutlet weak var lastMessageContentLabel: UILabel!
    @IBOutlet weak var lastMessageTimeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        senderImageView.layer.cornerRadius = senderImageView.frame.width / 2
        senderImageView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
