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
    
    func loadNewsTab() {
    
        let _: Promise<[NewsTab]> =  RequestManager.request(router: Router.endPointwithoutValid(path: NewsRequest.getNewsTab, param: nil))
    }
    
    func loadExamples(vc: UIViewController) -> Observable<[Example]> {
        let numberExample = Example()
        numberExample.name = "Numbers"
        numberExample.handler = {
            guard let numbervc = UIStoryboard(name: "News", bundle: nil).instantiateViewController(withIdentifier: "NumberVC") as? NumberVC else { return }
            vc.navigationController?.pushViewController(numbervc, animated: true)
        }
        let simpleValid = Example()
        simpleValid.name = "SimpleVaid"
        simpleValid.handler = {
            guard let simpleValidVC = UIStoryboard(name: "News", bundle: nil).instantiateViewController(withIdentifier: "SimpleValidationVC") as? SimpleValidationVC else { return }
            vc.navigationController?.pushViewController(simpleValidVC, animated: true)
        }
      return  Observable<[Example]>.just([numberExample, simpleValid])
    }
}
