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
    
    private var uid: String?
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let defaults = NSUserDefaults.standardUserDefaults()
        uid = defaults.stringForKey("currentUid")
    }
    
    deinit {
        self.ref.child("snoozed").removeObserverWithHandle(_refHandle)
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
        
        _refHandle = self.ref.child("snoozed/\(uid!)").observeEventType(.ChildAdded, withBlock: { (snapshot) -> Void in
            self.feeds.append(snapshot)
            self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: self.feeds.count-1, inSection: 0)], withRowAnimation: .Automatic)
            self.activityIndicator.stopAnimation()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feeds.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("RSSFeedTableViewCell", forIndexPath: indexPath) as! RSSFeedTableViewCell
        
        let feedSnapshot: FIRDataSnapshot! = self.feeds[indexPath.row]
        let feed = feedSnapshot.value as! Dictionary<String, String>
        
        cell.titleLabel.text = feed[Constants.MessageFields.title] as String!
        cell.contentLabel.text = feed[Constants.MessageFields.content] as String!
        cell.publishedLabel.text = feed[Constants.MessageFields.published] as String!
        cell.feedId = feedSnapshot.key as String!
        
        let imageUrl = feed[Constants.MessageFields.heroImage] as String!
        
        cell.heroImageView.sd_setImageWithURL(NSURL(string: imageUrl), placeholderImage: UIImage(named: "icepeak-placeholder"))
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }

}
