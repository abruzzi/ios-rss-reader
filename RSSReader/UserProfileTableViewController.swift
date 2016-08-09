//
//  UserProfileTableViewController.swift
//  RSSReader
//
//  Created by Juntao Qiu on 8/7/16.
//  Copyright © 2016 Juntao Qiu. All rights reserved.
//

import UIKit

class UserProfileTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.estimatedRowHeight = 45.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if(section == 0) {
            return 1
        } else if(section == 1){
            return 1
        }
        
        return 0
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        var cell: UITableViewCell
        
        if(indexPath.section == 0 && indexPath.row == 0) {
            let cell = tableView.dequeueReusableCellWithIdentifier("UserInfoTableViewCell", forIndexPath: indexPath) as! UserInfoTableViewCell
            cell.userNameLabel.text = "Juntao"
            cell.avatarImage.sd_setImageWithURL(NSURL(string: ""), placeholderImage: UIImage(named: "icepeak-placeholder"))
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("SignoutTableViewCell", forIndexPath: indexPath) as! SignoutTableViewCell
            return cell
        }
        
//        return cell
    }
}
