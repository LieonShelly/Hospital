//
//  AuthorizedManager.swift
//  Hospital
//
//  Created by lieon on 2017/6/5.
//  Copyright © 2017年 ChangHongCloudTechService. All rights reserved.
//

import UIKit
import Photos

class AuthorizedManager {
    public enum AuthorizedType {
        case mic
        case camera
        case album
    }
    
    public static func requestAuthroization(with type: AuthorizedType, callback: @escaping ((AuthorizedType,  Bool) -> Void)) {
        if type == .mic {
            requestMicAuthorizatuonStatus(callback)
        }
        if type == .camera {
            requestCameraAuthorizatuonStatus(callback)
        }
        if type == .album {
            requestAlbumAuthorizatuonStatus(callback)
        }
    }
    
    public static func checkAuthorization(with type: AuthorizedType) -> Bool {
        if  type == .mic {
            return AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeAudio) == .authorized
        }
        if  type == .camera {
            return AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo) == .authorized
        }
        if  type == .album {
            return PHPhotoLibrary.authorizationStatus() == .authorized
        }
        return false
    }
    
    static private func requestMicAuthorizatuonStatus(_ callback: @escaping ((AuthorizedType, Bool) -> Void)) {
         let status = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeAudio)
        if status == .authorized {
            DispatchQueue.main.async {
                callback(.mic, true)
            }
        }
        if status == .notDetermined {
            AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeAudio, completionHandler: { granted in
                DispatchQueue.main.async {
                    callback(.mic, granted)
                }
            })
        }
        if status == .denied {
            DispatchQueue.main.async {
                callback(.mic, false)
            }
            openAuthorizationSetting()
        }
    }
    
    static public func openAuthorizationSetting() {
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!)
        }
    }
    
    static private func requestCameraAuthorizatuonStatus(_ callback: @escaping ((AuthorizedType, Bool) -> Void)) {
        let status = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
        if status == .authorized {
            DispatchQueue.main.async {
                callback(.camera, true)
            }
        }
        if status == .notDetermined {
            AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: { granted in
                DispatchQueue.main.async {
                    callback(.camera, granted)
                }
            })
        }
        if status == .denied {
            DispatchQueue.main.async {
                callback(.camera, false)
            }
            openAuthorizationSetting()
        }
    }
    
    static private func requestAlbumAuthorizatuonStatus(_ callback: @escaping ((AuthorizedType, Bool) -> Void)) {
        let status = PHPhotoLibrary.authorizationStatus()
        if status == .authorized {
            DispatchQueue.main.async {
                callback(.album, true)
            }
        }
        if status == .notDetermined {
            PHPhotoLibrary.requestAuthorization({ granted in
                DispatchQueue.main.async {
                    callback(.album, granted == .authorized)
                }
            })
        }
        if status == .denied {
            DispatchQueue.main.async {
                callback(.album, false)
            }
            openAuthorizationSetting()
        }
    }
}
