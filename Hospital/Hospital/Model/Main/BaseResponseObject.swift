//
//  BaseResponseObject.swift
//  Hospital
//
//  Created by lieon on 2017/4/17.
//  Copyright © 2017年 ChangHongCloudTechService. All rights reserved.
//

import Foundation
import ObjectMapper

class BaseResponseObject: Model {
    var isError: Bool = false
    var errorType: ErrorType = .noError
    var errorMessage: String?
    var result: String?
    
    override func mapping(map: Map) {
        isError <- map["error"]
        errorType <- map["errorType"]
        errorMessage <- map["errorMessage"]
        result <- map["result"]
    }
}

enum ErrorType: String {
    case noError = "0"
    case cookieVerifyFaild = "1"
    
    var title: String {
        switch self {
        case .noError:
            return "no error"
        default:
            return "Cookie Verify Faild"
        }
    }
}
