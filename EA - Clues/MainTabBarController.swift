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


class MainTabBarController: UITabBarController {
    
    var stdFrame: CGRect?
    
    override func viewDidLoad() {
        
//        self.tabBar.tintColor = UIColor.redColor()
        
        //MARK: CheckUser
        self.selectedIndex = 2
        
        
        // This will never happen
        if User.checkLogin(true, vc: nil) {
            if let pvc = self.viewControllers![1] as? ProfileWrapperViewController {
                pvc.showForUser()
            }
        }
    }

    
}
