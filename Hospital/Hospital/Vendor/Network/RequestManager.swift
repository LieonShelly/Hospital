//
//  RequestManager.swift
//  Hospital
//
//  Created by lieon on 2017/4/17.
//  Copyright © 2017年 ChangHongCloudTechService. All rights reserved.
//

import Foundation
import PromiseKit
import ObjectMapper
import Alamofire

protocol ProcessProtocol{
    var baseURL: String { get }
    var interface: String { get }
    var action: String { get }
    
    func URL() -> String
}

extension ProcessProtocol {
    /// http://111.26.203.161:8888/zsfy/interfaceConsultation!getDoctorConsultation.action?userId=232&answerUserId=2&currentPage=1
    func URL() -> String {
        return baseURL + interface + "!" + action + ".action?"
    }
}

protocol UserProcess: ProcessProtocol { }

extension UserProcess {
    var baseURL: String {
        return "http://111.26.203.161:8888/zsfy/"
    }
}

enum Router: URLRequestConvertible {
    case endPointwithValid(path: ProcessProtocol, param: Mappable?)
    case endPointwithoutValid(path: ProcessProtocol, param: Mappable?)
    var method: HTTPMethod {
        return .get
    }
    var param: Mappable? {
        switch self {
        case .endPointwithoutValid(_, let param):
            return param
        case .endPointwithValid(_, let param):
            return param
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        switch self {
        case .endPointwithoutValid(path: let path, _):
            let urlstr = path.URL()
            let url = URL(string: urlstr)
            return URLRequest(url: url!)
        case .endPointwithValid(path: let path, _):
            let urlstr = path.URL()
            let url = URL(string: urlstr)
            return URLRequest(url: url!)
        }
    }
}

class RequestManager {
    static func request<T: Mappable>(router: Router) -> Promise<T> {
        return Promise { fullfill, reject in
            Alamofire.request((router.urlRequest?.url)!, method: router.method, parameters: router.param?.toJSON(), encoding: URLEncoding.default, headers: nil).responseJSON(completionHandler: { dataResponse in
                switch dataResponse.result {
                case .success(let value):
                    guard let json = value as? [String: Any] else { return }
                    print(json)
                    guard  let baseResponseObject = Mapper<BaseResponseObject<T>>().map(JSON: json)else { return }
                    if baseResponseObject.isError {
                        let error = NSError(domain: baseResponseObject.errorType.title, code: Int(baseResponseObject.errorType.rawValue) ?? 0, userInfo: nil)
                        print("******server data response error*****")
                        print(error.localizedDescription)
                        reject(error as Error)
                    } else {
                        guard let result = baseResponseObject.result else { return }
                        print("********success*********")
                        print(result)
                        fullfill(result)
                    }
                case .failure(let error):
                    print("*******failre closure error*********")
                    print(error.localizedDescription)
                    reject(error)
                }
            })
        }
    }
}
