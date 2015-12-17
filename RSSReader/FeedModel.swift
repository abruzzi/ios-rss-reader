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
    
    init(title: String, author: String, content: String) {
        self.title = title
        self.author = author
        self.content = content
    }
    
    var dict = [String: String]()
    
    func toDict() -> [String: String] {
        dict["title"] = title
        dict["author"] = author
        dict["content"] = content
        
        return dict;
    }
}

