//
//  Hero.swift
//  Hospital
//
//  Created by lieon on 2017/5/3.
//  Copyright © 2017年 ChangHongCloudTechService. All rights reserved.
//

import Foundation
import ObjectMapper

class Hero: Model {
    var name: String?
    
   override func mapping(map: Map) {
        name <- map["name"]
    }
}
