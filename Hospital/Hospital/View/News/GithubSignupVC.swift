//
//  GithubSignupVC.swift
//  Hospital
//
//  Created by lieon on 2017/5/9.
//  Copyright © 2017年 ChangHongCloudTechService. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class GithubSignupVC: BaseViewController {
    @IBOutlet weak var usernameOutlet: UITextField!
    @IBOutlet weak var usernameValidationOutlet: UILabel!
    @IBOutlet weak var passwordOutlet: UITextField!
    @IBOutlet weak var passwordValidationOutlet: UILabel!
    @IBOutlet weak var repeatedPasswordOutlet: UITextField!
    @IBOutlet weak var repeatedPasswordValidationOutlet: UILabel!
    @IBOutlet weak var signupOutlet: UIButton!
    @IBOutlet weak var signingUpOulet: UIActivityIndicatorView!
    private let usernameminLength: Int = 5
    private let passwordminLength: Int = 6
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    fileprivate func setupUI() {
       let  signupVM = GithubSignupViewModel(
                                input: (
                                    username: usernameOutlet.rx.text.orEmpty.asObservable(),
                                    password: passwordOutlet.rx.text.orEmpty.asObservable(),
                                    repeatPassword: repeatedPasswordOutlet.rx.text.orEmpty.asObservable(),
                                    signupTaps: signupOutlet.rx.tap.asObservable()),
                                dependency: (
                                    API: GithubDefaultAPI.sahred,
                                    service: GitHubDefaultValidationService.shared)
        )
        signupVM.validatedUsername
            .bind(to: usernameValidationOutlet.rx.validationResult)
            .disposed(by: disposeBag)
        signupVM.validatedPassword
            .bind(to: passwordValidationOutlet.rx.validationResult)
            .disposed(by: disposeBag)
        signupVM.validatedRepeatPassword
            .bind(to: repeatedPasswordValidationOutlet.rx.validationResult)
            .disposed(by: disposeBag)
        signupVM.signingin
            .bind(to: signingUpOulet.rx.isAnimating)
            .disposed(by: disposeBag)
        signupVM.signedin
            .subscribe(onNext: {  signedIn in
            print("User signed in \(signedIn)")
        })
            .disposed(by: disposeBag)
        let tap = UITapGestureRecognizer()
        tap.rx.event.subscribe(onNext: { [weak self] _ in
            self?.view.endEditing(true)
        }).disposed(by: disposeBag)
        view.addGestureRecognizer(tap)
       
    }
}









