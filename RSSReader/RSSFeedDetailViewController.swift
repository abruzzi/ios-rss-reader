//
//  RSSFeedDetailViewController.swift
//  RSSReader
//
//  Created by Juntao Qiu on 12/18/15.
//  Copyright © 2015 Juntao Qiu. All rights reserved.
//

import UIKit
import Firebase

import NVActivityIndicatorView

class RSSFeedDetailViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    
    var activityIndicator = NVActivityIndicatorView(frame: CGRect(x: 20, y: 20, width: 32, height: 32), type: .Orbit, color: UIColor.orangeColor())
    
    var feedSnapshot: FIRDataSnapshot!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(activityIndicator)
        activityIndicator.frame = CGRect(x: (view.frame.width-40)/2, y: (view.frame.height-40)/2, width: 40, height: 40)
        self.loadPage()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        activityIndicator.startAnimation()
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        activityIndicator.stopAnimation()
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
