//
//  LoginViewController.swift
//  EpicAppventures
//
//  Created by James Birtwell on 28/12/2015.
//  Copyright © 2015 James Birtwell. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
//import ParseFacebookUtilsV4
import AVKit
import AVFoundation

protocol LoginViewControllerDelegate {
    func skippedLogin ()
}

class LoginViewController: UIViewController {
    
    var delegate: LoginViewControllerDelegate?
    var player: AVPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addVideoPlayer()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func skipSignIn(sender: UIButton) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
         NSNotificationCenter.defaultCenter().postNotificationName(skipLoginNotification, object: self)
    }
    
    @IBAction func facebookLogin(sender: UIButton) {
        
        
//        PFFacebookUtils.logInInBackgroundWithReadPermissions(fbLoginParameters, block: { (object:PFUser?, error:NSError?) -> Void in
//                        if(error != nil)
//                {//Display an alert message
//                    let myAlert = UIAlertController(title:"Alert", message:error?.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert);
//                    let okAction =  UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
//                    myAlert.addAction(okAction);
//                    self.presentViewController(myAlert, animated:true, completion:nil);
//                    return
//                        } else {
//                            self.dismissViewControllerAnimated(true, completion: nil)
//                            if PFUser.currentUser()?.objectId == nil {
//                                //still a problem
//                            } else {
//                                User.user = User(pfUser: PFUser.currentUser()!)
//                                NSNotificationCenter.defaultCenter().postNotificationName(User.userInitCompleteNotification, object: self)
//                            }
//            }
//            self.dismissViewControllerAnimated(true, completion: nil)
//            
//        })
        
    }
    
    func addVideoPlayer() {
        
        // Load the video from the app bundle.
        let videoURL: NSURL = NSBundle.mainBundle().URLForResource("video", withExtension: "mov")!
        
        player = AVPlayer(URL: videoURL)
        player?.actionAtItemEnd = .None
        player?.muted = true
        
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        playerLayer.zPosition = -1
        
        playerLayer.frame = view.frame
        
        view.layer.addSublayer(playerLayer)
        
        player?.play()
        
        //loop video
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: "loopVideo",
                                                         name: AVPlayerItemDidPlayToEndTimeNotification,
                                                         object: nil)
    }
    
    func loopVideo() {
        player?.seekToTime(kCMTimeZero)
        player?.play()
    }
}
