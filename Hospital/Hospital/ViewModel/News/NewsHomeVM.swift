//
//  NewsHomeVM.swift
//  Hospital
//
//  Created by lieon on 2017/4/17.
//  Copyright © 2017年 ChangHongCloudTechService. All rights reserved.
//

import Foundation
import PromiseKit
import UIKit
import RxSwift
import  CoreData

class NewsHomeVM {
    
    func loadNewsTab() {
    
        let _: Promise<[NewsTab]> =  RequestManager.request(router: Router.endPointwithoutValid(path: NewsRequest.getNewsTab, param: nil))
    }
    
    func loadExamples(vc: UIViewController) -> Observable<[Example]> {
        let numberExample = Example()
        numberExample.name = "Numbers"
        numberExample.handler = {
            guard let numbervc = UIStoryboard(name: "News", bundle: nil).instantiateViewController(withIdentifier: "NumberVC") as? NumberVC else { return }
            vc.navigationController?.pushViewController(numbervc, animated: true)
        }
        let simpleValid = Example()
        simpleValid.name = "SimpleVaid"
        simpleValid.handler = {
            guard let simpleValidVC = UIStoryboard(name: "News", bundle: nil).instantiateViewController(withIdentifier: "SimpleValidationVC") as? SimpleValidationVC else { return }
            vc.navigationController?.pushViewController(simpleValidVC, animated: true)
        }
        let GithubSignup = Example()
        GithubSignup.name = "GithubSignup"
        GithubSignup.handler = {
            guard let githubSignupVC = UIStoryboard(name: "News", bundle: nil).instantiateViewController(withIdentifier: "GithubSignupVC") as? GithubSignupVC else { return }
            vc.navigationController?.pushViewController(githubSignupVC, animated: true)
        }
        let imagePicker = Example()
        imagePicker.name = "ImagePicker"
        imagePicker.handler = {
            guard let imagePickerVC = UIStoryboard(name: "News", bundle: nil).instantiateViewController(withIdentifier: "ImagePickerVC") as? ImagePickerVC else { return }
            vc.navigationController?.pushViewController(imagePickerVC, animated: true)
        }
      return  Observable<[Example]>.just([numberExample, simpleValid, GithubSignup, imagePicker])
    }
    
    func save() {
        let user: User = User(context: (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext)
        user.account = "accout@gmail.com"
        user.password = "12345"
        user.name = "lieon"
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
    func fectchUser() -> Observable<[User]>{
       return Observable<[User]>.create {  obsever in
            let request: NSFetchRequest<User> = User.fetchRequest()
            guard let result =  try? ((UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext).fetch(request) else {
            obsever.on(.completed)
                return  Disposables.create()
                }
            obsever.on(.next(result))
            return Disposables.create()
        }
      
        
    }
}
