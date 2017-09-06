//
//  ImagePickerVC.swift
//  Hospital
//
//  Created by lieon on 2017/5/16.
//  Copyright © 2017年 ChangHongCloudTechService. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class ImagePickerVC: BaseViewController {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var cameraButton: UIButton!
    @IBOutlet var galleryButton: UIButton!
    @IBOutlet var cropButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        cameraButton.rx.tap.asObservable()
            .flatMapLatest { [weak self] _ in
            return UIImagePickerController.rx.createWithParent(parent: self, animated: true, configureImagePicker: { imagePicker in
                imagePicker.sourceType = .camera
                imagePicker.allowsEditing = false
            }).flatMap{ $0.rx.didFinishPickingMediaWithInfo}
                /// 取第一个元素
            .take(1)
        }
            .map { info in
                return info[UIImagePickerControllerOriginalImage] as? UIImage
        }
        .bind(to: imageView.rx.image)
        .disposed(by: disposeBag)
        
        galleryButton.rx.tap.asObservable()
            .flatMapLatest { [weak self] _  in
                return UIImagePickerController.rx.createWithParent(parent: self, animated: true, configureImagePicker: { ( imagePicker: UIImagePickerController) in
                    imagePicker.sourceType = .photoLibrary
                    imagePicker.allowsEditing = false
            })
                    .flatMap { $0.rx.didFinishPickingMediaWithInfo}
                .take(1)
        }
            .map { info in
                return info[UIImagePickerControllerOriginalImage] as? UIImage
        }
        .bind(to: imageView.rx.image)
        .disposed(by: disposeBag )
        
        cropButton.rx.tap.asObservable()
        .flatMapLatest { [weak self] _ in
            return UIImagePickerController.rx.createWithParent(parent: self, animated: true, configureImagePicker: { imagePicker in
                imagePicker.allowsEditing = true
                imagePicker.sourceType = .photoLibrary
            }).flatMap {$0.rx.didFinishPickingMediaWithInfo}
            .take(1)
        }
            .map { info in
                return info[UIImagePickerControllerOriginalImage] as? UIImage
        }
        .bind(to: imageView.rx.image)
        .disposed(by: disposeBag)
    }
    

}

extension Reactive where Base: UIImagePickerController {
    /// 创建一个 相机 序列
    static func createWithParent(parent: UIViewController?, animated: Bool = true, configureImagePicker: @escaping (UIImagePickerController) throws -> () = { x in }) -> Observable<UIImagePickerController> {
        return Observable.create({ [weak parent] observer in
            let imagePicker = UIImagePickerController()
            let dismissDisposeabele = imagePicker.rx
            .didCancel
            .subscribe(onNext: { [weak imagePicker] in
                guard let imagePicker = imagePicker else {
                return
                }
                self.dismissViewController(imagePicker, animated: animated)
            })
            do {
                try configureImagePicker(imagePicker)
            }
            catch let error {
                observer.on(.error(error))
                return Disposables.create()
            }
            guard let parent = parent else {
                observer.on(.completed)
                return Disposables.create()
            }
            parent.present(imagePicker, animated: animated, completion: nil)
            observer.on(.next(imagePicker))
            return Disposables.create(dismissDisposeabele, Disposables.create {
                dismissViewController(imagePicker, animated: animated)
            })
            
        })
    }
    
    private static func dismissViewController(_ viewController: UIViewController, animated: Bool) {
        if viewController.isBeingDismissed || viewController.isBeingPresented {
            DispatchQueue.main.async {
                dismissViewController(viewController, animated: animated)
            }
            return
        }
        if viewController.presentingViewController != nil {
            viewController.dismiss(animated: animated, completion: nil)
        }
    }
}

extension Reactive where Base: UIImagePickerController {
    /**
     Reactive wrapper for `delegate` message.
     */
    public var didFinishPickingMediaWithInfo: Observable<[String : AnyObject]> {
        return delegate
            /// 监听方法是否都调用
            .methodInvoked(#selector(UIImagePickerControllerDelegate.imagePickerController(_:didFinishPickingMediaWithInfo:)))
            .map({ (a) in
                return try self.castOrThrow(Dictionary<String, AnyObject>.self, a[1])
            })
    }
    
    /**
     Reactive wrapper for `delegate` message.
     */
    public var didCancel: Observable<()> {
        return delegate
            .methodInvoked(#selector(UIImagePickerControllerDelegate.imagePickerControllerDidCancel(_:)))
            .map {_ in () }
    }
    fileprivate func castOrThrow<T>(_ resultType: T.Type, _ object: Any) throws -> T {
        guard let returnValue = object as? T else {
            throw RxCocoaError.castingError(object: object, targetType: resultType)
        }
        
        return returnValue
    }
}

