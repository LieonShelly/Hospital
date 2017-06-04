//
//  FristViewController.swift
//  Hospital
//
//  Created by lieon on 2017/6/3.
//  Copyright © 2017年 ChangHongCloudTechService. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class FristViewController: BaseViewController {

    fileprivate lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: UIScreen.main.bounds)
        return scrollView
    }()
    let storyVC: StoryViewController = StoryViewController()
    let pageVc = FirstSubViewController()
    var lastPage: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    deinit {
        scrollView.removeObserver(self, forKeyPath: "contentOffset")
    }
}

extension FristViewController {
   fileprivate  func setupUI()  {
        scrollView.backgroundColor = .white
        scrollView.contentSize = CGSize(width: UIScreen.width * 2, height: 0)
    scrollView.contentOffset = CGPoint(x: UIScreen.width, y: 0)
    scrollView.showsVerticalScrollIndicator = false
    scrollView.showsHorizontalScrollIndicator = false
    scrollView.isPagingEnabled = true
    scrollView.bounces = false
    scrollView.scrollsToTop = false
    scrollView.delegate = self
    storyVC.view.frame = CGRect(x: 0, y: -64, width: UIScreen.width, height: UIScreen.height)
    scrollView.addSubview(storyVC.view)
    addChildViewController(storyVC)
    pageVc.view.frame = CGRect(x: UIScreen.width, y: 0, width: UIScreen.width, height: UIScreen.height)
    scrollView.addSubview(pageVc.view)
    addChildViewController(pageVc)
    view.addSubview(scrollView)
    lastPage = 1
    scrollView.addObserver(self, forKeyPath: "contentOffset", options: .new, context: nil)
    /// 用rxswift简化KVO
//    scrollView.rx.observe(CGPoint.self, "contentOffset").subscribe(onNext: { contentOffset in
//        print(contentOffset ?? .zero)
//    }).disposed(by: disposeBag)
    }

    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentOffset" {
            let offsetX = scrollView.contentOffset.x
            if offsetX < UIScreen.width {
                tabBarController?.tabBar.transform = CGAffineTransform(translationX: UIScreen.width - offsetX, y: 0)
                navigationController?.navigationBar.transform = CGAffineTransform(translationX: UIScreen.width - offsetX, y: 0)
            } else {
                tabBarController?.tabBar.transform = CGAffineTransform.identity
                navigationController?.navigationBar.transform = .identity
            }
        }
    }
}

extension FristViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x / UIScreen.width)
        if lastPage == page {
            return
        }
        lastPage = page
        // FIXME:openCamera
        print("*****cameraVC******")
    }
}

