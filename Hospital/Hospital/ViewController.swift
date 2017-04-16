//
//  ViewController.swift
//  Hospital
//
//  Created by lieon on 2017/4/16.
//  Copyright © 2017年 ChangHongCloudTechService. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        /*
         1.到底是post还是get
         2.https的适配，现在用的是http
         3. 是否需要参数加密
         
         */
        Alamofire.request("http://111.26.203.161:8888/zsfy/interfaceLogin.action?", method: .post, parameters: ["loginName": "sky水电费fgfger12", "password": "123456"] as Parameters).responseJSON { response in
            switch response.result {
            case .success( let value):
                print("****success****:\(value)")

            case .failure(let error):
                print("****failure****:\(error)")
            }
        }
        
        
    }

}

