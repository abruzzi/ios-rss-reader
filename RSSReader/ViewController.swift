//
//  ViewController.swift
//  RSSReader
//
//  Created by Juntao Qiu on 12/15/15.
//  Copyright © 2015 Juntao Qiu. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import ObjectMapper

class ViewController: UIViewController, UITableViewDataSource {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        Alamofire.request(.GET, "http://127.0.0.1:8080/api/feeds").validate().responseJSON { response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    self.data = Mapper<RSSFeed>().mapArray(value)!
                    self.tableView.reloadData()
                }
            case .Failure(let error):
                print(error)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet weak var tableView: UITableView!
    
    var data:[RSSFeed] = []
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("RSSFeedTableViewCell", forIndexPath: indexPath) as! RSSFeedTableViewCell
        
        let current = data[indexPath.row]
        
        cell.titleLabel.text = current.title
        cell.contentLabel.text = current.content
        cell.publishedLabel.text = current.published
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("loadFeed", sender: indexPath)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "loadFeed", let destination = segue.destinationViewController as?
            RSSFeedDetailViewController {
            if let indexPath = sender as? NSIndexPath {
                destination.feed = data[indexPath.row]
            }
        }
    }
    
    func refreshUI() {
        tableView.reloadData()
    }

}

