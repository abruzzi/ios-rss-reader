//
//  RSSFeedTableViewCell.swift
//  RSSReader
//
//  Created by Juntao Qiu on 12/17/15.
//  Copyright © 2015 Juntao Qiu. All rights reserved.
//

import UIKit

class RSSFeedTableViewCell: UITableViewCell {

    @IBOutlet weak var heroImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var publishedLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
