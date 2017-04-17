//
//  NewsHomeVM.swift
//  Hospital
//
//  Created by lieon on 2017/4/17.
//  Copyright © 2017年 ChangHongCloudTechService. All rights reserved.
//

import Foundation
import PromiseKit

class NewsHomeVM {
    
    func loadNewsTab() {
    
        let tab: Promise<[NewsTab]> =  RequestManager.request(router: Router.endPointwithoutValid(path: NewsRequest.getNewsTab, param: nil))
    }
}
