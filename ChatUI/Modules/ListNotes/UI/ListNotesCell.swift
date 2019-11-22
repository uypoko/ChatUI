//
//  ListNotesCell.swift
//  ChatUI
//
//  Created by Ryan on 11/19/19.
//  Copyright © 2019 Daylighter. All rights reserved.
//

import UIKit

class ListNotesCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func bind(title: String?, date: Date, content: String) {
        titleLabel.text = title
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        let dateString = dateFormatter.string(from: date)
        dateLabel.text = dateString
        contentLabel.text = content
    }

}
