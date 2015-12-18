//
//  RSSFeedDetailViewController.swift
//  RSSReader
//
//  Created by Juntao Qiu on 12/18/15.
//  Copyright © 2015 Juntao Qiu. All rights reserved.
//

import UIKit

class RSSFeedDetailViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    
    var feed: RSSFeed!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadPage()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadPage() {
        if(self.feed.url != nil){
            let request: NSURLRequest = NSURLRequest.init(URL: NSURL(string: self.feed.url!)!)
            self.webView.loadRequest(request)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
