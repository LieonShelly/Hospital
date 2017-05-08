//
//  SimpleValidationVC.swift
//  Hospital
//
//  Created by lieon on 2017/5/8.
//  Copyright © 2017年 ChangHongCloudTechService. All rights reserved.
//

import UIKit
import  RxCocoa
import RxSwift

class SimpleValidationVC: BaseViewController {
    @IBOutlet weak var usernameOutlet: UITextField!
    @IBOutlet weak var usernameValidOutlet: UILabel!
    @IBOutlet weak var passwordOutlet: UITextField!
    @IBOutlet weak var passwordValidOutlet: UILabel!
    @IBOutlet weak var doSomethingOutlet: UIButton!
    
    private let minimallUsernameLength: Int = 5
    private let minimalPasswordLength: Int = 5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    fileprivate func setupUI() {
        usernameValidOutlet.text = "Username has to be at least \(minimallUsernameLength) characters"
        passwordValidOutlet.text = "Password has to be at least \(minimalPasswordLength) characters"
        let usernameValid = usernameOutlet.rx.text.orEmpty.map { (text) -> Bool in
            return text.characters.count >= self.minimallUsernameLength
        }.shareReplay(1)
        let passwordValid = passwordOutlet.rx.text.orEmpty.map{$0.characters.count >= self.minimalPasswordLength}
        let everythingValid = Observable.combineLatest(usernameValid, passwordValid) {$0 && $1}.shareReplay(1)
        everythingValid.bind(to: doSomethingOutlet.rx.isEnabled).disposed(by: disposeBag)
        doSomethingOutlet.rx.tap.subscribe(onNext: {
            print("*******doSomethingOutlet*******")
        }).disposed(by: disposeBag)
        usernameValid.bind(to: passwordOutlet.rx.isEnabled).disposed(by: disposeBag)
        usernameValid.bind(to: usernameValidOutlet.rx.isHidden).disposed(by: disposeBag)
        passwordValid.bind(to: passwordValidOutlet.rx.isHidden).disposed(by: disposeBag)
        
    }
}
