//
//  StoryViewController.swift
//  Hospital
//
//  Created by lieon on 2017/6/3.
//  Copyright © 2017年 ChangHongCloudTechService. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class StoryViewController: UIViewController {
    fileprivate lazy var cameraView: CameraView = {
        let cameraView = CameraView(frame: self.view.bounds)
        return cameraView
    }()
    fileprivate lazy var startBtn: UIButton = {
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        return btn
    }()
    fileprivate lazy var flashBtn: UIButton = {
        let btn = UIButton()
        btn.showsTouchWhenHighlighted = true
        btn.setImage(#imageLiteral(resourceName: "story_publish_icon_flashlight_auto"), for: .normal)
        btn.addTarget(self, action: #selector(self.flashAction(btn:)), for: .touchUpInside)
        return btn
    }()
    fileprivate lazy var switchBtn: UIButton = {
        let btn = UIButton()
        btn.showsTouchWhenHighlighted = true
        btn.setImage(#imageLiteral(resourceName: "story_publish_icon_cam_turn"), for: .normal)
        btn.addTarget(self, action: #selector(self.switchAction(btn:)), for: .touchUpInside)
        return btn
    }()
    fileprivate lazy var photoLibraryHintView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        return view
    }()
    fileprivate lazy var photoLibraryPicker: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: self.view.bounds.height, width: self.view.bounds.width, height: 165))
        return view
    }()
    fileprivate lazy var albumBlurCoverView: UIVisualEffectView = {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.light))
        return view
    }()
    fileprivate lazy var cameraBlurCoverView: UIVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.light))
    fileprivate var swipeUp: UISwipeGestureRecognizer?
    fileprivate var swipeDown: UISwipeGestureRecognizer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

}

extension StoryViewController {
    fileprivate func setupUI() {
        view.backgroundColor = .black
        view.isUserInteractionEnabled = true
        view.addSubview(cameraView)
        startBtn.center = CGPoint(x: view.center.x, y: view.bounds.height - 52 - 40)
        view.addSubview(startBtn)
        flashBtn.sizeToFit()
        flashBtn.center = CGPoint(x: startBtn.center.x - 100, y: startBtn.center.y)
        view.addSubview(flashBtn)
        switchBtn.sizeToFit()
        switchBtn.center = CGPoint(x: startBtn.center.x + 100, y: startBtn.center.y)
        view.addSubview(switchBtn)
        view.addSubview(photoLibraryHintView)
        view.addSubview(photoLibraryPicker)
        view.addSubview(albumBlurCoverView)
        albumBlurCoverView.frame = view.bounds
        albumBlurCoverView.isHidden = true
        albumBlurCoverView.isUserInteractionEnabled = true
        view.addSubview(cameraBlurCoverView)
        cameraBlurCoverView.frame = view.bounds
        swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeAction))
        swipeUp?.direction = .up
        checkAuthorized()
    }
    
    fileprivate func checkAuthorized() {
        
    }
    @objc fileprivate func flashAction(btn: UIButton) {
        let mode = cameraView.flashStatusChange()
        let imags = [
            AVCaptureTorchMode.on: #imageLiteral(resourceName: "story_publish_icon_flashlight_on"),
            AVCaptureTorchMode.off: #imageLiteral(resourceName: "story_publish_icon_flashlight_off"),
            AVCaptureTorchMode.auto: #imageLiteral(resourceName: "story_publish_icon_flashlight_auto")]
        btn.setImage(imags[mode], for: .normal)
    }
    
    @objc fileprivate func switchAction(btn: UIButton) {
        UIView.animate(withDuration: 0.3, animations: { 
            btn.transform = btn.transform.rotated(by: CGFloat.pi)
        }) { _ in
            self.cameraView.rotateCamera()
        }
    }
    
    @objc fileprivate func swipeAction(sender: UISwipeGestureRecognizer) {
        photoLibraryPicker(isHidden: sender.direction == .down)
    }
    
    fileprivate func  photoLibraryPicker(isHidden: Bool) {
        if isHidden {
            UIView.animate(withDuration: 0.25, animations: { 
                self.albumBlurCoverView.alpha = 0
                self.view.frame.origin.y += 165
            }, completion: { _ in
                self.albumBlurCoverView.isHidden = true
            })
            if let swip = swipeDown {
                self.view.removeGestureRecognizer(swip)
            }
        } else {
            // FIXME:Load Photo
//            photoLibraryPicker?.loadPhotos()
            albumBlurCoverView.isHidden = false
            UIView.animate(withDuration: 0.25, animations: { 
                self.cameraBlurCoverView.alpha = 1
                self.view.frame.origin.y -= 165
            }, completion: nil)
            swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(sender:)))
            swipeDown?.direction = .down
            view.addGestureRecognizer(swipeDown!)
        }
    }
}







