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


var centralDispatchGroup = DispatchGroup()

class LoginViewController: UIViewController {
    
    var delegate: LoginViewControllerDelegate?
    var player: AVPlayer?
    
    let backendless = Backendless.sharedInstance()
    var user = BackendlessUser()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addVideoPlayer()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func skipSignIn(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
         NotificationCenter.default.post(name: Notification.Name(rawValue: skipLoginNotification), object: self)
    }


    @IBAction func facebookLogin(_ sender: UIButton) {
        centralDispatchGroup.enter()
        UserManager.loginWithFacebook()
        centralDispatchGroup.notify(queue: .main) {
            UserManager.mapBackendlessToCoreUser()
            self.dismiss(animated: true, completion: nil)
        }
    }

    
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
        
    
    func addVideoPlayer() {
        
        // Load the video from the app bundle.
        let videoURL: URL = Bundle.main.url(forResource: "video", withExtension: "mov")!
        
        player = AVPlayer(url: videoURL)
        player?.actionAtItemEnd = .none
        player?.isMuted = true
        
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        playerLayer.zPosition = -1
        
        playerLayer.frame = view.frame
        
        view.layer.addSublayer(playerLayer)
        
        player?.play()
        
        //loop video
        NotificationCenter.default.addObserver(self,
                                                         selector: #selector(LoginViewController.loopVideo),
                                                         name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                                         object: nil)
    }
    
    func loopVideo() {
        player?.seek(to: kCMTimeZero)
        player?.play()
    }
}
