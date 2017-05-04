//
//  NewsHomeVM.swift
//  Hospital
//
//  Created by lieon on 2017/4/17.
//  Copyright © 2017年 ChangHongCloudTechService. All rights reserved.
//

import Foundation
import PromiseKit
import UIKit
import RxSwift

class NewsHomeVM {
   lazy var examples: [Example] = [Example]()
    
    func loadNewsTab() {
    
        let _: Promise<[NewsTab]> =  RequestManager.request(router: Router.endPointwithoutValid(path: NewsRequest.getNewsTab, param: nil))
    }
    
    func loadExamples(vc: UIViewController, callback: () -> ()) {
        let numberExample = Example()
        numberExample.name = "Numbers"
        numberExample.handler = {
            
        }
        examples.append(numberExample)
    }
}
