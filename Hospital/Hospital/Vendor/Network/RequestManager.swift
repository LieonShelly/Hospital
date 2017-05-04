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
import RxSwift

protocol ProcessProtocol{
    var baseURL: String { get }
    var interface: String { get }
    var action: String { get }
    
    func URL() -> String
}

extension ProcessProtocol {
    func URL() -> String {
        return baseURL + interface + "!" + action + ".action?"
    }
}

protocol UserProcess: ProcessProtocol { }
protocol LocalHostProcess: ProcessProtocol { }

extension UserProcess {
    var baseURL: String {
        return "http://111.26.203.161:8888/zsfy/"
    }

}

extension LocalHostProcess {
    var baseURL: String {
        return "http://localhost:3000"
    }
    
    func URL() -> String {
        return baseURL + interface + action
    }
}

enum Router: URLRequestConvertible {
    case endPointwithValid(path: ProcessProtocol, param: Mappable?)
    case endPointwithoutValid(path: ProcessProtocol, param: Mappable?)
    var method: HTTPMethod {
        return .post
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
            var request = URLRequest(url: url!)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            return request
        case .endPointwithValid(path: let path, _):
            let urlstr = path.URL()
            let url = URL(string: urlstr)
            return URLRequest(url: url!)
        }
    }
}

class RequestManager {
    
    static func request<T: Mappable>(router: Router) -> Observable<T> {
      return  Observable<T>.create { (observer) -> Disposable in
            Alamofire.request((router.urlRequest?.url)!, method: router.method, parameters: router.param?.toJSON(), encoding: URLEncoding.default, headers: nil).responseJSON(completionHandler: { dataResponse in
                switch dataResponse.result {
                case .success(let value):
                    guard let json = value as? [String: Any] else { return }
                    print(json)
                    guard  let baseResponseObject = Mapper<BaseResponseObject>().map(JSON: json)else { return }
                    if baseResponseObject.isError {
                        let error = NSError(domain: baseResponseObject.errorType.title, code: Int(baseResponseObject.errorType.rawValue) ?? 0, userInfo: nil)
                        print("******server data response error*****")
                        print(error.localizedDescription)
                        observer.onError(error)
                    } else {
                        guard let result = baseResponseObject.result, let obj = Mapper<T>().map(JSONString: result) else { return }
                        observer.onNext(obj)
                        observer.onCompleted()
                    }
                case .failure(let error):
                    print("*******failre closure error*********")
                    print(error.localizedDescription)
                    observer.onError(error)
                }
            })
            return Disposables.create()

        }
    }
    
    static func request<T: Mappable>(router: Router) -> Promise<T> {
        return Promise { fullfill, reject in
            Alamofire.request((router.urlRequest?.url)!, method: router.method, parameters: router.param?.toJSON(), encoding: URLEncoding.default, headers: nil).responseJSON(completionHandler: { dataResponse in
                switch dataResponse.result {
                case .success(let value):
                    guard let json = value as? [String: Any] else { return }
                    print(json)
                    guard  let baseResponseObject = Mapper<BaseResponseObject>().map(JSON: json)else { return }
                    if baseResponseObject.isError {
                        let error = NSError(domain: baseResponseObject.errorType.title, code: Int(baseResponseObject.errorType.rawValue) ?? 0, userInfo: nil)
                        print("******server data response error*****")
                        print(error.localizedDescription)
                        reject(error as Error)
                    } else {
                        guard let result = baseResponseObject.result, let obj = Mapper<T>().map(JSONString: result) else { return }
                        print(obj)
                        fullfill(obj)
                    }
                case .failure(let error):
                    print("*******failre closure error*********")
                    print(error.localizedDescription)
                    reject(error)
                }
            })
        }
    }
    
    static func request<T: Mappable>(router: Router) -> Promise<[T]> {
        return Promise { fullfill, reject in
            Alamofire.request((router.urlRequest?.url)!, method: router.method, parameters: router.param?.toJSON(), encoding: URLEncoding.default, headers: nil).responseJSON(completionHandler: { dataResponse in
                switch dataResponse.result {
                case .success(let value):
                    guard let json = value as? [String: Any] else { return }
                    print(json)
                    guard  let baseResponseObject = Mapper<BaseResponseObject>().map(JSON: json)else { return }
                    
                    if baseResponseObject.isError {
                        let error = NSError(domain: baseResponseObject.errorType.title, code: Int(baseResponseObject.errorType.rawValue) ?? 0, userInfo: nil)
                        print("******server data response error*****")
                        print(error.localizedDescription)
                        reject(error as Error)
                    } else {
                        print("********success*********")
                        guard let result = baseResponseObject.result, let objectArray = Mapper<T>().mapArray(JSONString: result)
                          else { return }
                        print(objectArray)
                        fullfill(objectArray)
                    }
                case .failure(let error):
                    print("*******failre closure error*********")
                    print(error.localizedDescription)
                    reject(error)
                }
            })
        }
    }
    
    static func request<T: Mappable>(router: Router) -> Observable<[T]> {
        return  Observable<[T]>.create { (observer) -> Disposable in
            Alamofire.request((router.urlRequest?.url)!, method: router.method).responseJSON(completionHandler: { dataResponse in
                switch dataResponse.result {
                case .success(let value):
                    guard let json = value as? [String: Any] else { return }
                    guard  let baseResponseObject = Mapper<BaseResponseObject>().map(JSON: json)else { return }
                    if baseResponseObject.isError {
                        let error = NSError(domain: baseResponseObject.errorType.title, code: Int(baseResponseObject.errorType.rawValue) ?? 0, userInfo: nil)
                        print("******server data response error*****")
                        print(error.localizedDescription)
                        observer.onError(error)
                    } else {
                        guard let result = baseResponseObject.result, let objectArray = Mapper<T>().mapArray(JSONString: result)
                            else { return }
                        observer.on(.next(objectArray))
                    }
                case .failure(let error):
                    print("*******failre closure error*********")
                    print(error.localizedDescription)
                    observer.onError(error)
                }
            })
            return Disposables.create()
            
        }
    }
}
