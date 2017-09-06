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
    var newsTabId: Int?
    var title: String?
    
    override func mapping(map: Map) {
        newsTabId <- map["id"]
        title <- map["title"]
    }
}

class QuestionContents: Model {
    
}

class Example: Model {
    var name: String?
    var handler: (() -> ())?
}
