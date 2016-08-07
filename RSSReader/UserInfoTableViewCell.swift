//
//  UserInfoTableViewCell.swift
//  RSSReader
//
//  Created by Juntao Qiu on 8/7/16.
//  Copyright © 2016 Juntao Qiu. All rights reserved.
//

import UIKit

class UserInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        userNameLabel.text = AppState.sharedInstance.displayName
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
