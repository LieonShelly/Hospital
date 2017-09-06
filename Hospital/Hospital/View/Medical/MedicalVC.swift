//
//  MedicalVC.swift
//  Hospital
//
//  Created by lieon on 2017/6/2.
//  Copyright © 2017年 ChangHongCloudTechService. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class MedicalVC: BaseViewController {

//    https://mu.mumov.com/videoMsKFz7jB7kBdD0DjxKye3v6Wd0
   fileprivate lazy var player: PlayerView = {
        let player = PlayerView(frame: CGRect(x: 0, y: 64, width: UIScreen.main.bounds.width, height: 200))
        player.videoURL = "https://mu.mumov.com/videoMsKFz7jB7kBdD0DjxKye3v6Wd0"
        player.backgroundColor = UIColor.yellow
        return player
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(player)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}
