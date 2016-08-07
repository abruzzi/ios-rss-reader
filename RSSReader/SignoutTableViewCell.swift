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
        AppState.sharedInstance.displayName = ""
        AppState.sharedInstance.signedIn = false
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.removeObjectForKey("currentUid")
        defaults.removeObjectForKey("currentEmail")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
