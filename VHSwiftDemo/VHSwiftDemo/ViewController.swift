//
//  ViewController.swift
//  VHSwiftDemo
//
//  Created by vhall on 2018/3/26.
//  Copyright © 2018年 vhall. All rights reserved.
//

import UIKit

class ViewController: UIViewController , VHallMoviePlayerDelegate{
    
    var player:VHallMoviePlayer = VHallMoviePlayer()

    @IBOutlet weak var textField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        player = VHallMoviePlayer.init(delegate: self)
        
//        player.renderViewModel = .origin
        player.moviePlayerView.frame = self.view.bounds
        self.view.insertSubview(player.moviePlayerView, at: 0)
       
//        let param = ["id":"570683535","name":"name","email":"email@c.com"]
//        player.startPlay(param)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.

    }
    @IBAction func liveStart(_ sender: Any) {
        let livevc:WatchLiveViewController = WatchLiveViewController()
        livevc.roomId = textField.text;
        livevc.kValue = "";
        livevc.bufferTimes = 6;
        self.present(livevc, animated: true) {
            
        }
    }
    @IBAction func vodStart(_ sender: Any) {
        let vodvc:WatchPlayBackViewController = WatchPlayBackViewController()
        vodvc.roomId = textField.text;
        vodvc.kValue = "";
        vodvc.timeOut = 6000;
        self.present(vodvc, animated: true) {
            
        }
    }
    
    
    func playError(_ livePlayErrorType: VHLivePlayErrorType, info: [AnyHashable : Any]!) {
        print(info)
    }

}

