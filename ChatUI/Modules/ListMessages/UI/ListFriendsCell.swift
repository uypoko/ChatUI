//
//  ListSenderCell.swift
//  ChatUI
//
//  Created by Ryan on 11/6/19.
//  Copyright © 2019 Daylighter. All rights reserved.
//

import UIKit

class ListFriendsCell: UICollectionViewCell {
    
    @IBOutlet weak var friendNameLabel: UILabel!
    @IBOutlet weak var friendImageView: UIImageView!
    
    override func awakeFromNib() {
        friendImageView.layer.cornerRadius = (friendImageView.frame.width + 19) / 2
        friendImageView.clipsToBounds = true
    }
}
