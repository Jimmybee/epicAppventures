//
//  MainTabBarController.swift
//  EpicAppventures
//
//  Created by James Birtwell on 28/12/2015.
//  Copyright © 2015 James Birtwell. All rights reserved.
//

import UIKit
//import Parse
import FBSDKCoreKit


let statupDispatchGroup = DispatchGroup()

class MainTabBarController: UITabBarController {
    
    struct StoryboardNames {
        static let startupLogin = "startupLogin"
    }

    let backendless = Backendless.sharedInstance()

    var stdFrame: CGRect?
    var nilMe: String!
    
    override func viewDidLoad() {
        
//        self.tabBar.tintColor = UIColor.redColor()
        //MARK: CheckUser
        self.selectedIndex = 2
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UserManager.setupUser(completion: setupComplete)
    }

    func setupComplete() {
        if CoreUser.user?.userType == .noLogin {
            self.performSegue(withIdentifier: StoryboardNames.startupLogin, sender: nil)
            if let pvc = self.viewControllers![1] as? ProfileWrapperViewController {
                pvc.showForUser()
            }
        } else {
            NotificationCenter.default.post(name: Notification.Name(rawValue: Notifications.reloadCatalogue), object: self)
        }
    }
    
}
