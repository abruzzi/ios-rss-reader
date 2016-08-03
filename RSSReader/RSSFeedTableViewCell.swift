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
    
    var ref: FIRDatabaseReference!
    var feedId: String?
    
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
