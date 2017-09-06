//
//  Protocol.swift
//  Hospital
//
//  Created by lieon on 2017/5/9.
//  Copyright © 2017年 ChangHongCloudTechService. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol GithubAPI {
    func usernameAvaiable(_ username: String) -> Observable<Bool>
    func signup(username: String, password: String) -> Observable<Bool>
}

protocol GithubValidationService {
    func validateUsername(_ username: String) -> Observable<ValidateResult>
    func validtePassword(_ password: String) -> ValidateResult
    func validteRepeatedPassword(_ password: String, repeatePassword: String) -> ValidateResult
}

extension Reactive where Base: UILabel {
    var validationResult: UIBindingObserver<Base, ValidateResult> {
        return UIBindingObserver(UIElement: base) { label, result in
            label.textColor = result.textColor
            label.text = result.description
        }
    }
}
