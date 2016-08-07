//
//  SignInViewController.swift
//  RSSReader
//
//  Created by Juntao Qiu on 8/1/16.
//  Copyright © 2016 Juntao Qiu. All rights reserved.
//

import UIKit
import Firebase

import NVActivityIndicatorView

class SignInViewController: UIViewController {

//    @IBOutlet weak var activityIndicator: NVActivityIndicatorView!
    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var errorMessage: UILabel!
    
    var activityIndicator = NVActivityIndicatorView(frame: CGRect(x: 20, y: 20, width: 40, height: 40), type: .Orbit, color: UIColor.orangeColor())
    
    @IBAction func performSignIn(sender: AnyObject) {
        let name = userName.text
        let pass = password.text
        
        signInButton.enabled = false
        activityIndicator.startAnimation()
        
        FIRAuth.auth()?.signInWithEmail(name!, password: pass!) { (user, error) in
            if let error = error {
                self.activityIndicator.stopAnimation()
                self.signInButton.enabled = true
                
                self.errorMessage.text = error.localizedDescription
                self.errorMessage.hidden = false
                
                print(error.localizedDescription)
                return
            }
            self.signedIn(user!)
        }
    }
    
    func signedIn(user: FIRUser?) {
        AppState.sharedInstance.displayName = user?.displayName ?? user?.email
        AppState.sharedInstance.signedIn = true
        
        let defaults = NSUserDefaults.standardUserDefaults()
        if let uid = user?.uid {
            defaults.setObject(uid, forKey: "currentUid")
        }
        
        if let email = user?.email {
            defaults.setObject(email, forKey: "currentEmail")
        }
        
        activityIndicator.stopAnimation()
        NSNotificationCenter.defaultCenter().postNotificationName(Constants.NotificationKeys.SignedIn, object: nil, userInfo: nil)
        performSegueWithIdentifier(Constants.Segues.SignInToFp, sender: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        let x = (self.view.frame.width-40)/2
        let y = signInButton.frame.maxY+signInButton.frame.height+20
        
        activityIndicator.frame = CGRect(x: x, y: y, width: 40, height: 40)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.errorMessage.text = ""
        self.view.addSubview(activityIndicator)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
