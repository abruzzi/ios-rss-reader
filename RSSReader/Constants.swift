//
//  Constants.swift
//  RSSReader
//
//  Created by Juntao Qiu on 8/1/16.
//  Copyright © 2016 Juntao Qiu. All rights reserved.
//

import Foundation

struct Constants {
    struct NotificationKeys {
        static let SignedIn = "signedIn"
    }
    
    struct Segues {
        static let SignInToFp = "showFeedList"
    }
    
    struct MessageFields {
        static let id = "id"
        static let title = "title"
        static let url = "url"
        static let author = "author"
        static let content = "summary"
        static let published = "publishDate"
        static let heroImage = "heroImage"
    }
}