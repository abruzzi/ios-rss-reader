//
//  ViewController.swift
//  RSSReader
//
//  Created by Juntao Qiu on 12/15/15.
//  Copyright © 2015 Juntao Qiu. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UITableViewDataSource {

    @IBOutlet var rssLabel: UILabel!
    @IBOutlet var resultLabel: UILabel!
    @IBOutlet var source: UITextField!
    @IBOutlet var addRssButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        Alamofire.request(.GET, "https://httpbin.org/get").validate().responseJSON { response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let json = JSON(value)
                    print("JSON: \(json)")
                }
            case .Failure(let error):
                print(error)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet weak var tableView: UITableView!
    
    var data:[RSSFeed] = [
        RSSFeed(title: "使用graphviz绘制流程图", author: "邱俊涛", content: "2015年11月10日更新 在实践中，我又发现了一些graphviz的有趣的特性，比如时序图，rank以及图片节点等。在这里一并更新。"),
        RSSFeed(title: "你为什么应该试一试Reflux？", author: "邱俊涛", content: "React在设计之初就只关注在View本身上，其余部分如数据的获取，事件处理等，全然不在考虑之内。"),
        RSSFeed(title: "看看这些年你都学了什么？", author: "邱俊涛", content: "多年下来，我的Google Bookmarks里已经有近万条的书签。大部分内容是我在读过一遍之后就收藏起来的，也有很多看了一眼之后，觉得不错，然后收藏起来准备以后读的（当然，你也知道，再也没有打开过）。"),
        RSSFeed(title: "工程中的编译原理 – Mapfile解析器", author: "邱俊涛", content: "Mapfile是MapServer用来描述一个地图的配置文件。它是一个很简单的声明式语言，一个地图（Map）可以有多个层（Layer），每个层可以有很多属性（键值对）。"),
        RSSFeed(title: "工程中的编译原理 – Jison入门篇", author: "邱俊涛", content: "在代码编写中，很多时候我们都会处理字符串：发现字符串中的某些规律，然后将想要的部分抽取出来。"),
    ]
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Value2, reuseIdentifier: nil)
        
        let current = data[indexPath.row]
        
        cell.textLabel?.text = current.title
        cell.detailTextLabel?.text = current.content
        return cell
    }
    
    @IBAction func addButtonTapped(sender: AnyObject) {
        refreshUI()
    }
    
    func refreshUI() {
        resultLabel.text = "Result: \(source.text)"
        tableView.reloadData()
    }

}

