//
//  News.swift
//  Hospital
//
//  Created by lieon on 2017/4/17.
//  Copyright © 2017年 ChangHongCloudTechService. All rights reserved.
//

import Foundation
import ObjectMapper

class NewsTab: Model {
    var newsTabId: String?
    var title: String?
    var type: String?
    
    override func mapping(map: Map) {
        newsTabId <- map["id"]
        title <- map["title"]
        type <- map["type"]
    }
}
class  NewsColum: NSObject {
    var group: [NewsTab]?
}
