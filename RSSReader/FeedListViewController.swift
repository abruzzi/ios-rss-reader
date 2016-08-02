//
//  ViewController.swift
//  RSSReader
//
//  Created by Juntao Qiu on 12/15/15.
//  Copyright © 2015 Juntao Qiu. All rights reserved.
//

import UIKit

import Firebase
import SDWebImage

import NVActivityIndicatorView

class FeedListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var ref: FIRDatabaseReference!
    var feeds: [FIRDataSnapshot]! = []
    private var _refHandle: FIRDatabaseHandle!
    
    var activityIndicator = NVActivityIndicatorView(frame: CGRect(x: 20, y: 20, width: 32, height: 32), type: .BallTrianglePath, color: UIColor.orangeColor())
    
    deinit {
        self.ref.child("feeds").removeObserverWithHandle(_refHandle)
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
        _refHandle = self.ref.child("feeds").observeEventType(.ChildAdded, withBlock: { (snapshot) -> Void in
            self.feeds.append(snapshot)
            self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: self.feeds.count-1, inSection: 0)], withRowAnimation: .Automatic)
            self.activityIndicator.stopAnimation()
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet weak var tableView: UITableView!
    
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
        
        let imageUrl = feed[Constants.MessageFields.heroImage] as String!

        cell.heroImageView.sd_setImageWithURL(NSURL(string: imageUrl), placeholderImage: UIImage(named: "icepeak-placeholder"))
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: false)
        self.performSegueWithIdentifier("loadFeed", sender: indexPath)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "loadFeed", let destination = segue.destinationViewController as?
            RSSFeedDetailViewController {
            if let indexPath = sender as? NSIndexPath {
                destination.feedSnapshot = self.feeds[indexPath.row]
            }
        }
    }
    
    func refreshUI() {
        tableView.reloadData()
    }

}

