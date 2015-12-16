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

class RSSFeedDataSource: NSObject, UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    var data:[RSSFeed] = [
        RSSFeed(title: "使用graphviz绘制流程图", author: "邱俊涛", content: "2015年11月10日更新 在实践中，我又发现了一些graphviz的有趣的特性，比如时序图，rank以及图片节点等。在这里一并更新。"),
        RSSFeed(title: "你为什么应该试一试Reflux？", author: "邱俊涛", content: "React在设计之初就只关注在View本身上，其余部分如数据的获取，事件处理等，全然不在考虑之内。"),
        RSSFeed(title: "看看这些年你都学了什么？", author: "邱俊涛", content: "多年下来，我的Google Bookmarks里已经有近万条的书签。大部分内容是我在读过一遍之后就收藏起来的，也有很多看了一眼之后，觉得不错，然后收藏起来准备以后读的（当然，你也知道，再也没有打开过）。"),
    ]
    
    override init() {
        super.init()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Value2, reuseIdentifier: nil)
        
        let current = data[indexPath.row]
        
        cell.textLabel?.text = current.title
        cell.detailTextLabel?.text = current.content
        return cell
    }
}
