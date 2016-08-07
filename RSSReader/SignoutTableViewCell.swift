//
//  SignoutTableViewCell.swift
//  RSSReader
//
//  Created by Juntao Qiu on 8/7/16.
//  Copyright © 2016 Juntao Qiu. All rights reserved.
//

import UIKit

class SignoutTableViewCell: UITableViewCell {

    @IBOutlet weak var signOutButton: UIButton!
    
    @IBAction func signOut(sender: AnyObject) {
        print("signout...")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
