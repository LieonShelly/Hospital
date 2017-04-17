//
//  Model.swift
//  Hospital
//
//  Created by lieon on 2017/4/17.
//  Copyright © 2017年 ChangHongCloudTechService. All rights reserved.
//

import Foundation
import ObjectMapper

open class Model: Mappable {
    
    public init() {
        
    }
    
    required public init?(map: Map) {
        
    }
    
    open func mapping(map: Map) {
        
    }
    
}

extension Model: CustomDebugStringConvertible {
    
    public var debugDescription: String {
        var str = "\n"
        let properties = Mirror(reflecting: self).children
        for c in properties {
            if let name = c.label {
                str += name + ": \(c.value)\n"
            }
        }
        return str
    }
}
