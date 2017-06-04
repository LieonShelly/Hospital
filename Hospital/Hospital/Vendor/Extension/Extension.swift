//
//  Extension.swift
//  Hospital
//
//  Created by lieon on 2017/5/9.
//  Copyright © 2017年 ChangHongCloudTechService. All rights reserved.
//

import Foundation
import UIKit

extension String {
    var URLEscaped: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
    }
    
}

extension UIScreen {
    static  var width: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    static var height: CGFloat {
        return UIScreen.main.bounds.height
    }
}
