//
//  ViewController.swift
//  RSSReader
//
//  Created by Juntao Qiu on 12/15/15.
//  Copyright © 2015 Juntao Qiu. All rights reserved.
//

import UIKit

import Firebase

class FeedListViewController: UIViewController, UITableViewDataSource {
    
    var ref: FIRDatabaseReference!
    var feeds: [FIRDataSnapshot]! = []
    private var _refHandle: FIRDatabaseHandle!
    
    deinit {
        self.ref.child("feeds").removeObserverWithHandle(_refHandle)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDatabase()
    }
    
    func configureDatabase() {
        ref = FIRDatabase.database().reference()
        
        _refHandle = self.ref.child("feeds").observeEventType(.ChildAdded, withBlock: { (snapshot) -> Void in
            self.feeds.append(snapshot)
            self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: self.feeds.count-1, inSection: 0)], withRowAnimation: .Automatic)
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
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
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
