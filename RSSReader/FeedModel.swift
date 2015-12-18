//
//  FeedModel.swift
//  RSSReader
//
//  Created by Juntao Qiu on 12/15/15.
//  Copyright © 2015 Juntao Qiu. All rights reserved.
//

import Foundation
import ObjectMapper

class RSSFeed : Mappable {
    var title: String?
    var url: String?
    var author: String?
    var content: String?
    var published: String?
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        title      <- map["title"]
        url        <- map["url"]
        author     <- map["author"]
        content    <- map["summary"]
        published  <- map["publishDate"]
    }
}

