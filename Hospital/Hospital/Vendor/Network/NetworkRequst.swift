//
//  NetworkRequst.swift
//  Hospital
//
//  Created by lieon on 2017/4/17.
//  Copyright © 2017年 ChangHongCloudTechService. All rights reserved.
//

import Foundation

enum NewsRequest: UserProcess {
    case getNewsTab
    case getNewsList

    var interface: String {
        return "interfaceNews"
    }
    
    var action: String {
        switch self {
        case .getNewsTab:
            return "getNewsColumn"
        case .getNewsList:
            return "getNews"
        }
    }
}
