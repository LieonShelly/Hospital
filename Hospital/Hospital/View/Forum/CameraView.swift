//
//  CameraView.swift
//  Hospital
//
//  Created by lieon on 2017/6/3.
//  Copyright © 2017年 ChangHongCloudTechService. All rights reserved.
//

import UIKit
import GPUImage
import Foundation

private let MaxDragOffset:CGFloat = 300
class CameraView: GPUImageView {
    fileprivate var currentVideoPath: URL?
    fileprivate var currentPhotoPath: URL?
    fileprivate var moiveWriter: GPUImageMovieWriter?
    /// 滤镜
    fileprivate lazy var beautifyFilter = GPUImageFilter()
    fileprivate var videoCamera: GPUImageStillCamera?
    fileprivate var isAnimEnd: Bool = true
    fileprivate var tapGesture: UITapGestureRecognizer?
    fileprivate var doubleTapGesture: UITapGestureRecognizer?
    fileprivate lazy var focusAnim: CAAnimationGroup = {
        let zoomAnim = CABasicAnimation(keyPath: "transform.scale")
        zoomAnim.fromValue = 1.8
        zoomAnim.byValue = 0.8
        zoomAnim.toValue = 1
        zoomAnim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        let alphaAnim = CABasicAnimation(keyPath: "opacity")
        alphaAnim.fromValue = 1
        alphaAnim.toValue = 0
        let group = CAAnimationGroup()
        group.animations = [zoomAnim, alphaAnim]
        group.duration = 0.3
        group.isRemovedOnCompletion = false
        group.fillMode = kCAFillModeForwards
        return group
    }()
    fileprivate lazy var focusRing: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        view.backgroundColor = .clear
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 25
        view.isHidden = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapAction(tap:)))
        addGestureRecognizer(tapGesture!)
        doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.doubleTapAction(doubleTap:)))
        doubleTapGesture?.numberOfTapsRequired = 2
        addGestureRecognizer(doubleTapGesture!)
        tapGesture?.require(toFail: doubleTapGesture!)
        focusAnim.delegate = self
    }
    
    func initCamera() {
        /// AVCaptureSessionPreset1280x720视频采集的尺寸
        videoCamera = GPUImageStillCamera(sessionPreset: AVCaptureSessionPreset1280x720, cameraPosition: .back)
        videoCamera?.outputImageOrientation = .portrait
        videoCamera?.horizontallyMirrorFrontFacingCamera = true
        videoCamera?.removeAllTargets()
        videoCamera?.addTarget(beautifyFilter as GPUImageInput)
        beautifyFilter.addTarget(self)
    }
    
    func configVideoRecording() {
        // 视频输入
        let videoSetting:[String : Any] = [
            AVVideoCodecKey : AVVideoCodecH264,
            AVVideoWidthKey : 720,
            AVVideoHeightKey: 1280,
            AVVideoCompressionPropertiesKey:
                [
                    AVVideoProfileLevelKey : AVVideoProfileLevelH264Main31,
                    AVVideoAllowFrameReorderingKey : false,
                    //码率
                    AVVideoAverageBitRateKey : 720 * 1280 * 3
            ]
        ]
        currentVideoPath = getVideoFilePath()
        let size = CGSize(width: 720, height: 1280)
        moiveWriter = GPUImageMovieWriter(movieURL: currentVideoPath, size: size, fileType: AVFileTypeQuickTimeMovie, outputSettings: videoSetting)
        beautifyFilter.addTarget(moiveWriter)
        moiveWriter?.encodingLiveVideo = true
    }
    
    func configAudioRecording() {
        let audioSetting = [
            AVFormatIDKey: kAudioFormatMPEG4AAC,
            AVNumberOfChannelsKey: 2,
            AVSampleRateKey: 16000,
            AVEncoderBitRateKey: 32000
        ]
        moiveWriter?.setHasAudioTrack(true, audioSettings: audioSetting)
        videoCamera?.audioEncodingTarget = moiveWriter
    }
    
    func rotateCamera() {
        videoCamera?.rotateCamera()
    }
    
    func pauseCamera() {
        videoCamera?.pauseCapture()
    }
    
    func resumeCamera() {
        if let videoPath = currentVideoPath {
            do {
                try FileManager.default.removeItem(at: videoPath)
                currentVideoPath = nil
            } catch {
                print("video delete failure")
            }
        }
        if let photoPath = currentPhotoPath {
            do {
                try FileManager.default.removeItem(at: photoPath)
                currentVideoPath = nil
            } catch {
                print("photo delete failure")
            }
        }
        videoCamera?.resumeCameraCapture()
        setVideoZoomFactor(zoom: 0)
    }
    
    func finishRecording(complete: @escaping ((URL) -> Void)) {
        moiveWriter?.finishRecording(completionHandler: { [weak self] in
            DispatchQueue.main.async {
                self?.beautifyFilter.removeTarget(self?.moiveWriter)
                self?.videoCamera?.pauseCapture()
                self?.moiveWriter = nil
                if let path = self?.currentVideoPath {
                    complete(path)
                }
            }
        })
    }
    
    func capturePhoto(complete: @escaping ((URL?) -> Void)) {
        videoCamera?.capturePhotoAsImageProcessedUp(toFilter: beautifyFilter, with: .up, withCompletionHandler: { [weak self] (image, error) in
            DispatchQueue.main.async {
                self?.beautifyFilter.removeTarget(self?.moiveWriter)
                self?.videoCamera?.pauseCapture()
                self?.moiveWriter = nil
                guard let img = image else {
                    complete(nil)
                    return
                }
                let imageData = UIImagePNGRepresentation(img)
                self?.currentPhotoPath = self?.getPhtoFilePath()
                do {
                    try imageData?.write(to: self!.currentPhotoPath!)
                    complete(self?.currentVideoPath)
                } catch {
                    complete(nil)
                }
            }
        })
    }
    
    func flashStatusChange() -> AVCaptureTorchMode {
        if videoCamera!.inputCamera.hasFlash || videoCamera!.inputCamera.hasFlash {
            return .auto
        }
        let rawValue = videoCamera!.inputCamera.torchMode.rawValue + 1
        let mode = AVCaptureTorchMode(rawValue: rawValue + 1 > 3 ? 0: rawValue)!
        do {
            try videoCamera?.inputCamera.lockForConfiguration()
            videoCamera?.inputCamera.torchMode = mode
            videoCamera?.inputCamera.unlockForConfiguration()
        } catch {
            
        }
        return mode
    }
    
    func cameraSwitch(isOpen: Bool) {
        isOpen ? videoCamera?.startCapture(): videoCamera?.stopCapture()
    }
    
    func cameraZoom(offsetY: CGFloat) {
        let maxZommFactor = videoCamera?.inputCamera.activeFormat.videoMaxZoomFactor ?? 1
        let max = maxZommFactor > 20 ? 20: maxZommFactor
        let per = MaxDragOffset / max
        let zoom = offsetY / per
        setVideoZoomFactor(zoom: zoom)
    }
    
    func startCapture() {
        videoCamera?.startCapture()
    }
    
    func stopCapture() {
        videoCamera?.stopCapture()
    }
    
    func startRecording() {
        DispatchQueue.main.async {
            
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension CameraView {
    
    @objc fileprivate func tapAction(tap: UITapGestureRecognizer) {
        let point = tap.location(in: self)
        if !videoCamera!.inputCamera.isFocusModeSupported(.autoFocus) || !videoCamera!.inputCamera.isFocusPointOfInterestSupported {
            return
        }
        do {
            try videoCamera?.inputCamera.lockForConfiguration()
            videoCamera?.inputCamera.focusMode = .autoFocus
            videoCamera?.inputCamera.focusPointOfInterest = point
            videoCamera?.inputCamera.unlockForConfiguration()
        } catch {
            
        }
        showFocusRing(at: point)
    }
    
    @objc fileprivate func doubleTapAction(doubleTap: UITapGestureRecognizer) {
        roateCamera()
    }
    
    fileprivate func showFocusRing(at point: CGPoint) {
        if !isAnimEnd {
            return
        }
        focusRing.isHidden = false
        focusRing.center = point
        isAnimEnd = false
        focusRing.layer.add(focusAnim, forKey: nil)
    }
    
    fileprivate func roateCamera() {
        videoCamera?.rotateCamera()
    }
    
    fileprivate func setVideoZoomFactor(zoom: CGFloat) {
        do {
          try videoCamera?.inputCamera.lockForConfiguration()
            videoCamera?.inputCamera.videoZoomFactor = zoom + 1.0
            videoCamera?.inputCamera.unlockForConfiguration()
        } catch {
            
        }
    }
    
    fileprivate func getVideoFilePath() -> URL {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first?.appending("/storyvideo")
        let filePath = path?.appending("/\(Int(Date().timeIntervalSince1970)).mp4")
        do {
            try FileManager.default.createDirectory(atPath: path!, withIntermediateDirectories: true, attributes: nil)
        } catch {
            
        }
        return URL.init(fileURLWithPath: filePath!)
    }
    
    fileprivate func getPhtoFilePath() -> URL {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first?.appending("storyphoto")
        let filePath = path?.appending("/\(Int(Date().timeIntervalSince1970)).png")
        do {
            try FileManager.default.createDirectory(atPath: path!, withIntermediateDirectories: true, attributes: nil)
        } catch {
            print("********ERROR: getPhtoFilePath********")
        }
        return URL(fileURLWithPath: filePath!)
    }
}

extension CameraView: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if  flag == false {
            return
        }
        focusRing.layer.removeAllAnimations()
        focusRing.isHidden = true
        focusRing.alpha = 0
        isAnimEnd = true
    }
}

class CameraConfiguration {
    static var isOpenBeauty: Bool = false
}
