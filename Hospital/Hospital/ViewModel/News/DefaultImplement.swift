//
//  DefaultImplement.swift
//  Hospital
//
//  Created by lieon on 2017/5/9.
//  Copyright © 2017年 ChangHongCloudTechService. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class GithubDefaultAPI: GithubAPI {
    let URLSession: Foundation.URLSession
    static let sahred: GithubDefaultAPI =  GithubDefaultAPI(
        URLSession: Foundation.URLSession.shared
    )
    
    init(URLSession: Foundation.URLSession) {
        self.URLSession = URLSession
    }
    
    func usernameAvaiable(_ username: String) -> Observable<Bool> {
        let url = URL(string: "https://github.com/\(username.URLEscaped)")!
        let request = URLRequest(url: url)
        return self.URLSession.rx.response(request: request).map({ (response, _) -> Bool in
            return response.statusCode == 404
        }).catchErrorJustReturn(false)
    }
    
    func signup(username: String, password: String) -> Observable<Bool> {
        let signupResult = arc4random() % 5 == 0 ? false : true
        return Observable.just(signupResult).delay(1, scheduler: MainScheduler.instance)
    }
}

class GitHubDefaultValidationService: GithubValidationService {
    private let minLength: Int = 5
    private let API: GithubAPI
    static var shared: GitHubDefaultValidationService = GitHubDefaultValidationService(API: GithubDefaultAPI.sahred)
    init(API: GithubAPI) {
        self.API = API
    }
    
    func validateUsername(_ username: String) -> Observable<ValidateResult> {
        if username.isEmpty {
            return Observable<ValidateResult>.just(.empty)
        }
        if username.rangeOfCharacter(from: CharacterSet.alphanumerics.inverted) != nil {
            return Observable<ValidateResult>.just(.failed(message: "Username can only contain numbers or digits"))
        }
        return API.usernameAvaiable(username).map({ available -> ValidateResult in
            if available {
                return .ok(message: "Username available")
            } else {
                return .failed(message: "Username already taken")
            }
        }).startWith(.validating)
    }
    
    func validtePassword(_ password: String) -> ValidateResult {
        if password.isEmpty {
            return .empty
        }
        if password.characters.count < minLength{
            return .failed(message: "Password must be at least \(minLength) characters")
        }
        return .ok(message: "Password acceptable")
    }
    
    func validteRepeatedPassword(_ password: String, repeatePassword: String) -> ValidateResult {
        if repeatePassword.characters.count == 0 {
            return .empty
        }
        
        if repeatePassword == password {
            return .ok(message: "Password repeated")
        }
        else {
            return .failed(message: "Password different")
        }
    }
}
