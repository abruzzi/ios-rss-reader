//
//  RSSFeedDetailViewController.swift
//  RSSReader
//
//  Created by Juntao Qiu on 12/18/15.
//  Copyright © 2015 Juntao Qiu. All rights reserved.
//

import UIKit
import Firebase

class RSSFeedDetailViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    
    var feedSnapshot: FIRDataSnapshot!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadPage()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func loadPage() {
        let feed = feedSnapshot.value as! Dictionary<String, String>
        let url = feed[Constants.MessageFields.url] as String!
        
        if(url != nil){
            let request: NSURLRequest = NSURLRequest.init(URL: NSURL(string: url)!)
            self.webView.loadRequest(request)
        }
    }
    
}
