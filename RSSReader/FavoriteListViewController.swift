//
//  FavoriteListViewController.swift
//  RSSReader
//
//  Created by Juntao Qiu on 8/2/16.
//  Copyright © 2016 Juntao Qiu. All rights reserved.
//

import UIKit
import Firebase

import NVActivityIndicatorView

class FavoriteListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var ref: FIRDatabaseReference!
    var feeds: [FIRDataSnapshot]! = []
    private var _refHandle: FIRDatabaseHandle!
    
    var activityIndicator = NVActivityIndicatorView(frame: CGRect(x: 20, y: 20, width: 32, height: 32), type: .Orbit, color: UIColor.orangeColor())
    
    deinit {
        self.ref.child("favorites").removeObserverWithHandle(_refHandle)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(activityIndicator)
        configureDatabase()
    }
    
    func configureDatabase() {
        ref = FIRDatabase.database().reference()
        
        activityIndicator.frame = CGRect(x: (view.frame.width-32)/2, y: (view.frame.height-32)/2, width: 32, height: 32)
        activityIndicator.startAnimation()
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let uid = defaults.stringForKey("currentUid")
        print(uid)
        
        _refHandle = self.ref.child("favorites/\(uid!)").observeEventType(.ChildAdded, withBlock: { (snapshot) -> Void in
            self.feeds.append(snapshot)
            print(snapshot)
            print(self.feeds.count)
            self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: self.feeds.count-1, inSection: 0)], withRowAnimation: .Automatic)
            self.activityIndicator.stopAnimation()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //feedInfo
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feeds.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FavoriteFeedTableViewCell", forIndexPath: indexPath) as! FavoriteFeedCellTableViewCell
        
        let feedSnapshot: FIRDataSnapshot! = self.feeds[indexPath.row]
        let feedId = feedSnapshot.value as! String
//        cell.feedInfo.text = feed[Constants.MessageFields.title] as String!
        cell.feedInfo.text = feedId
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }

}
