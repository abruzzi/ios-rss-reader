//
//  RSSFeedTableViewCell.swift
//  RSSReader
//
//  Created by Juntao Qiu on 12/17/15.
//  Copyright © 2015 Juntao Qiu. All rights reserved.
//

import UIKit
import Firebase

import MCSwipeTableViewCell

class RSSFeedTableViewCell: MCSwipeTableViewCell {

    @IBOutlet weak var heroImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var publishedLabel: UILabel!
    
    @IBOutlet weak var favoriteButton: UIButton!
    
    var ref: FIRDatabaseReference!
    var feedId: String?
    
    @IBAction func addToFavorite(sender: UIButton) {
        print("saving... "+feedId!)
        let defaults = NSUserDefaults.standardUserDefaults()
        if let uid = defaults.stringForKey("currentUid") {
            ref.child("favorites/\(uid)/\(feedId!)")
                .setValue(feedId)
        }
        favoriteButton.setBackgroundImage(UIImage(named: "star-full"), forState: UIControlState.Normal)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureDatabase()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    

    
    func configureDatabase() {
        ref = FIRDatabase.database().reference()
    }
}
