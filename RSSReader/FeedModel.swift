//
//  FeedModel.swift
//  RSSReader
//
//  Created by Juntao Qiu on 12/15/15.
//  Copyright © 2015 Juntao Qiu. All rights reserved.
//

import Foundation
import UIKit

class RSSFeed {
    let title: String
    let author: String
    let content: String
    let published: String
    
    init(title: String, author: String, content: String, published: String) {
        self.title = title
        self.author = author
        self.content = content
        self.published = published
    }
}

