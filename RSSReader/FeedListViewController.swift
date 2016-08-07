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

import MCSwipeTableViewCell
import UIColor_Hex_Swift

class FeedListViewController: UIViewController, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    var ref: FIRDatabaseReference!
    var recommendations: [FIRDataSnapshot]! = []
    
    private var _refHandle: FIRDatabaseHandle!
    
    var activityIndicator = NVActivityIndicatorView(frame: CGRect(x: 20, y: 20, width: 40, height: 40), type: .BallRotate, color: UIColor.orangeColor())
    
    private var uid: String?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let defaults = NSUserDefaults.standardUserDefaults()
        uid = defaults.stringForKey("currentUid")
    }
    
    deinit {
        self.ref.child("recommendations").removeObserverWithHandle(_refHandle)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.emptyDataSetSource = self
        self.tableView.emptyDataSetDelegate = self
        self.tableView.tableFooterView = UIView()
        
        self.view.addSubview(activityIndicator)
        loadRecommendations()
    }

    func loadRecommendations() {
        ref = FIRDatabase.database().reference()
        
        activityIndicator.frame = CGRect(x: (view.frame.width-40)/2, y: (view.frame.height-40)/2, width: 40, height: 40)
        activityIndicator.startAnimation()
        
        _refHandle = self.ref.child("recommendations/\(uid!)").observeEventType(.ChildAdded, withBlock: { (snapshot) -> Void in
            self.recommendations.append(snapshot)
            self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: self.recommendations.count-1, inSection: 0)], withRowAnimation: .Automatic)
            self.activityIndicator.stopAnimation()
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBOutlet weak var tableView: UITableView!
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.recommendations.count
    }
 
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("RSSFeedTableViewCell", forIndexPath: indexPath) as! RSSFeedTableViewCell
        
        print(self.recommendations.count)
        
        let feedSnapshot: FIRDataSnapshot! = self.recommendations[indexPath.row]
        let feed = feedSnapshot.value as! Dictionary<String, String>
        
        cell.titleLabel.text = feed[Constants.MessageFields.title] as String!
        cell.contentLabel.text = feed[Constants.MessageFields.content] as String!
        cell.publishedLabel.text = feed[Constants.MessageFields.published] as String!
        cell.feedId = feedSnapshot.key as String!
        
        let imageUrl = feed[Constants.MessageFields.heroImage] as String!
        
        cell.heroImageView.sd_setImageWithURL(NSURL(string: imageUrl), placeholderImage: UIImage(named: "icepeak-placeholder"))
        
        self.configureCell(cell, indexPath: indexPath)
        
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
                destination.feedSnapshot = self.recommendations[indexPath.row]
            }
        }
    }

    func imageForEmptyDataSet(scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "earth")
    }
    
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "No recommendations for you now"
        let attribs = [
            NSFontAttributeName: UIFont.boldSystemFontOfSize(18),
            NSForegroundColorAttributeName: UIColor.lightGrayColor()
        ]
        
        return NSAttributedString(string: text, attributes: attribs)
    }
    
    func emptyDataSetShouldAllowScroll(scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func configureCell(cell: MCSwipeTableViewCell, indexPath: NSIndexPath) {
        let clockViewImage =  UIImage(named: "alarm-clock")
        let clockView = UIImageView(image: clockViewImage)
        
        cell.setSwipeGestureWithView(clockView, color: UIColor(rgba: "#5CB52A"), mode: MCSwipeTableViewCellMode.Exit, state:MCSwipeTableViewCellState.State3, completionBlock: { cell, state, mode in
            let current = cell as! RSSFeedTableViewCell
            self.snoozeCurrent(cell: current, indexPath: indexPath)
            return ()
        });
        
        let listViewImage = UIImage(named: "checkmark")
        let listView = UIImageView(image: listViewImage)
        
        cell.setSwipeGestureWithView(listView, color: UIColor(rgba: "#F48D3B"), mode: MCSwipeTableViewCellMode.Exit, state:MCSwipeTableViewCellState.State4, completionBlock: { cell, state, mode in
            let current = cell as! RSSFeedTableViewCell
            self.deleteCell(cell: current, indexPath: indexPath)
            return ()
        });
    }
    
    func snoozeCurrent(cell cell: RSSFeedTableViewCell, indexPath: NSIndexPath) {
        tableView.beginUpdates()
        let feedSnapshot: FIRDataSnapshot! = self.recommendations[indexPath.row]
        let value = feedSnapshot.value as! Dictionary<String, String>
        
        self.ref.child("snoozed/\(uid!)/\(cell.feedId!)").setValue(value)
        self.ref.child("recommendations/\(uid!)/\(cell.feedId!)").removeValue()
        
        self.recommendations.removeAtIndex(recommendations.indexOf(feedSnapshot)!)
        tableView.indexPathForCell(cell)
        tableView.deleteRowsAtIndexPaths([self.tableView.indexPathForCell(cell)!], withRowAnimation: .Left)
        
        tableView.endUpdates()
    }
    
    func deleteCell(cell cell: RSSFeedTableViewCell, indexPath: NSIndexPath) {
        tableView.beginUpdates()
        let feedSnapshot: FIRDataSnapshot! = self.recommendations[indexPath.row]
        
        self.ref.child("recommendations/\(uid!)/\(cell.feedId!)").removeValue()
        
        self.recommendations.removeAtIndex(recommendations.indexOf(feedSnapshot)!)
        tableView.indexPathForCell(cell)
        tableView.deleteRowsAtIndexPaths([self.tableView.indexPathForCell(cell)!], withRowAnimation: .Left)
        
        tableView.endUpdates()
    }
}

