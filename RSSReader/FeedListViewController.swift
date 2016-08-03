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
import DZNEmptyDataSet

class FeedListViewController: UIViewController, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    var ref: FIRDatabaseReference!
    var feeds: [FIRDataSnapshot]! = []
    private var _refHandle: FIRDatabaseHandle!
    
    var activityIndicator = NVActivityIndicatorView(frame: CGRect(x: 20, y: 20, width: 32, height: 32), type: .BallTrianglePath, color: UIColor.orangeColor())
    
    deinit {
        self.ref.child("feeds").removeObserverWithHandle(_refHandle)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.emptyDataSetSource = self
        self.tableView.emptyDataSetDelegate = self
        self.tableView.tableFooterView = UIView()
        
        self.view.addSubview(activityIndicator)
        configureDatabase()
    }
    
    func configureDatabase() {
        ref = FIRDatabase.database().reference()
        
        activityIndicator.frame = CGRect(x: (view.frame.width-32)/2, y: (view.frame.height-32)/2, width: 32, height: 32)
        activityIndicator.startAnimation()
        _refHandle = self.ref.child("feeds").queryLimitedToFirst(12).observeEventType(.ChildAdded, withBlock: { (snapshot) -> Void in
            self.feeds.append(snapshot)
            self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: self.feeds.count-1, inSection: 0)], withRowAnimation: .Automatic)
            self.activityIndicator.stopAnimation()
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        print(view.frame.height)
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
        cell.feedId = feedSnapshot.key as String!
        
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

    func imageForEmptyDataSet(scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "cog")
    }
    
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "You have no items"
        let attribs = [
            NSFontAttributeName: UIFont.boldSystemFontOfSize(18),
            NSForegroundColorAttributeName: UIColor.darkGrayColor()
        ]
        
        return NSAttributedString(string: text, attributes: attribs)
    }
    
    func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "Add items to track the things that are important to you. Add your first item by tapping the + button."
        
        let para = NSMutableParagraphStyle()
        para.lineBreakMode = NSLineBreakMode.ByWordWrapping
        para.alignment = NSTextAlignment.Center
        
        let attribs = [
            NSFontAttributeName: UIFont.systemFontOfSize(14),
            NSForegroundColorAttributeName: UIColor.lightGrayColor(),
            NSParagraphStyleAttributeName: para
        ]
        
        return NSAttributedString(string: text, attributes: attribs)
    }
    
    func emptyDataSetShouldAllowScroll(scrollView: UIScrollView!) -> Bool {
        return true
    }
}

