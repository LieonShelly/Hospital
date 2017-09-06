//
//  FaceDectorVC.swift
//  Hospital
//
//  Created by lieon on 2017/5/15.
//  Copyright © 2017年 ChangHongCloudTechService. All rights reserved.
//

import UIKit
import CoreImage

class FaceDectorVC: UIViewController {
    @IBOutlet weak var personImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func uploadAction(_ sender: Any) {
    
//        _ = fileProvider.create(folder: "FTPTest", at: "/") { (error) in
//            print("create:\(error.debugDescription)")
//        }
        
//        let urlStr = Bundle.main.url(forResource: "test2.txt", withExtension: nil)
//        let txtData = try? Data(contentsOf: urlStr!, options: Data.ReadingOptions.alwaysMapped)
//       let handle = fileProvider.writeContents(path: "/test2.txt", contents: txtData!, atomically: true, overwrite: true) { (error) in
//            print("writeContentserror:-----\(error.debugDescription )")
//        }
    }
    
    @IBAction func listAction(_ sender: Any) {
    }
    private func faceDector() {
        guard let image = personImageView.image else {
            return
        }
        guard let personciImage = CIImage(image: image) else {
            return        }
        let transform = CGAffineTransform(scaleX: 1, y: -1).translatedBy(x: 0, y: -personciImage.extent.height)
        let accuracy = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
        let faceDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: accuracy)
        let faces = faceDetector?.features(in: personciImage)
         let ciImageSize = personciImage.extent.size
        faces?.forEach({ face in
//            // Apply the transform to convert the coordinates
//            var faceViewBounds = face.bounds.applying(transform)
//            
//            // Calculate the actual position and size of the rectangle in the image view
//            let viewSize = personImageView.bounds.size
//            let scale = min(viewSize.width / ciImageSize.width,
//                            viewSize.height / ciImageSize.height)
//            let offsetX = (viewSize.width - ciImageSize.width * scale) / 2
//            let offsetY = (viewSize.height - ciImageSize.height * scale) / 2
//            
//            faceViewBounds = faceViewBounds.applying(CGAffineTransform(scaleX: scale, y: scale))
//            faceViewBounds.origin.x += offsetX
//            faceViewBounds.origin.y += offsetY
//            
//            let faceBox = UIView(frame: faceViewBounds)
//            
//            faceBox.layer.borderWidth = 3
//            faceBox.layer.borderColor = UIColor.red.cgColor
//            faceBox.backgroundColor = UIColor.clear
//            personImageView.addSubview(faceBox)

            print(face.bounds)
            var facebounds = face.bounds.applying(transform)
            let viewSize = self.personImageView.bounds.size
            let scale = min(viewSize.width / ciImageSize.width, viewSize.height / ciImageSize.height)
            let offsetX = (viewSize.width - ciImageSize.width * scale) * 0.5
            let offsetY = (viewSize.height - ciImageSize.height * scale) * 0.5
            facebounds = facebounds.applying(CGAffineTransform(scaleX: scale, y: scale))
            facebounds.origin.x += offsetX
            facebounds.origin.y += offsetY
            let faceBox = UIView(frame: facebounds)
            faceBox.layer.borderWidth = 3
            faceBox.layer.borderColor = UIColor.blue.cgColor
            faceBox.backgroundColor = UIColor.clear
            self.personImageView.addSubview(faceBox)
        })
    }
    
}
