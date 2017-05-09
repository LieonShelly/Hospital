//
//  GithubSignupViewModel.swift
//  Hospital
//
//  Created by lieon on 2017/5/9.
//  Copyright © 2017年 ChangHongCloudTechService. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

enum ValidateResult {
    case ok(message: String)
    case failed(message: String)
    case validating
    case empty
}

extension ValidateResult {
   var  isValid: Bool {
    switch self {
    case .ok:
        return true
    default:
        return false
    }
    }
    
    struct ValidationColors {
        static let okColor = UIColor(red: 138.0 / 255.0, green: 221.0 / 255.0, blue: 109.0 / 255.0, alpha: 1.0)
        static let errorColor = UIColor.red
    }

    var description: String {
        switch self {
        case let .ok(message):
            return message
        case .empty:
            return ""
        case .validating:
            return "validating ..."
        case let .failed(message):
            return message
        }
    }
    
    var textColor: UIColor {
        switch self {
        case .ok:
            return ValidationColors.okColor
        case .empty:
            return UIColor.black
        case .validating:
            return UIColor.black
        case .failed:
            return ValidationColors.errorColor
        }
    }
}

class  GithubSignupViewModel {
    let validatedUsername: Observable<ValidateResult>
    let validatedPassword: Observable<ValidateResult>
    let validatedRepeatPassword: Observable<ValidateResult>
    let signupEnable: Observable<Bool>
    let signedin: Observable<Bool>
    let signingin: Observable<Bool>
    
    init(input: (
                username: Observable<String>,
                password: Observable<String>,
                repeatPassword: Observable<String>,
                signupTaps: Observable<Void>
        ),
         dependency: (
                API: GithubAPI,
                service: GithubValidationService
        )) {
        validatedUsername = input.username.flatMapLatest({ String -> Observable<ValidateResult> in
            return dependency.service.validateUsername(String).observeOn(MainScheduler.instance)
            .catchErrorJustReturn(ValidateResult.failed(message: "Error contacting server"))
        }).shareReplay(1)
        validatedPassword = input.password.map({ password -> ValidateResult in
            return dependency.service.validtePassword(password)
        }).shareReplay(1)
        validatedRepeatPassword = Observable.combineLatest(input.password, input.repeatPassword, resultSelector: { (password, repearPassword) in
             return dependency.service.validteRepeatedPassword(password, repeatePassword: repearPassword)
        }).shareReplay(1)
        let usernameAndPassword = Observable.combineLatest(input.username, input.password) { (username, password)  in
            return(username, password)
        }.shareReplay(1)
        let signingIn = ActivityIndicator()
        self.signingin = signingIn.asObservable()
        
        signedin = input.signupTaps.withLatestFrom(usernameAndPassword).flatMapLatest { (username, password) in
            return dependency.API.signup(username: username, password: password).observeOn(MainScheduler.instance)
            .catchErrorJustReturn(false)
            .trackActivity(signingIn)
        }.shareReplay(1)
        
        signupEnable = Observable.combineLatest(validatedUsername, validatedPassword, validatedRepeatPassword, signingin.asObservable(), resultSelector: { (username, password, repeatedPassword, signingIn) -> Bool in
            return username.isValid && password.isValid && repeatedPassword.isValid && !signingIn
        }).distinctUntilChanged()
        .shareReplay(1)
    }
}
