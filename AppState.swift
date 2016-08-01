//
//  AppState.swift
//  RSSReader
//
//  Created by Juntao Qiu on 8/1/16.
//  Copyright © 2016 Juntao Qiu. All rights reserved.
//

import Foundation

class AppState {
    var displayName: String?
    var photoUrl: NSURL?
    var signedIn = false
    
    static let sharedInstance = AppState()
}