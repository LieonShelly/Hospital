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
        /* usernameOutlet.rx.text 将usernameOutlet的text值映射为一个ControlProperty<String?>类的序列
         通过map在映射为 一个 bool值，
         shareReplay是为了使序列处于活跃状态
        */
        let usernameValid = usernameOutlet.rx.text.orEmpty.map { (text) -> Bool in
            return text.characters.count >= self.minimallUsernameLength
        }.shareReplay(1)
        let passwordValid = passwordOutlet.rx.text.orEmpty.map{$0.characters.count >= self.minimalPasswordLength}
        /*combineLatest 是链接两个序列，闭包中的参数，是这个两个序列的真实值，通过这两个真实值的一些运算，再返回一个新的序列
         */
        let everythingValid = Observable.combineLatest(usernameValid, passwordValid) {$0 && $1}.shareReplay(1)
        everythingValid.bind(to: doSomethingOutlet.rx.isEnabled).disposed(by: disposeBag)
        /*  doSomethingOutlet.rx.tap.subscribe(onNext:) 直接用于监听按钮的点击操作
         disposed(by: disposeBag) 表示序列执行一次进入完成状态*/
        doSomethingOutlet.rx.tap.subscribe(onNext: {
            print("*******doSomethingOutlet*******")
        }).disposed(by: disposeBag)
        usernameValid.bind(to: passwordOutlet.rx.isEnabled).disposed(by: disposeBag)
        usernameValid.bind(to: usernameValidOutlet.rx.isHidden).disposed(by: disposeBag)
        passwordValid.bind(to: passwordValidOutlet.rx.isHidden).disposed(by: disposeBag)
        
    }
}
