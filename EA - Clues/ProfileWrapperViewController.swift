//
//  ProfileWrapperViewController.swift
//  EA - Clues
//
//  Created by James Birtwell on 09/08/2016.
//  Copyright © 2016 James Birtwell. All rights reserved.
//

import UIKit

class ProfileWrapperViewController: UIViewController {

    @IBOutlet weak var containerForUser: UIView!
    @IBOutlet weak var containerForSignIn: UIView!
    
    var embeddedSettings: SettingsTableViewController!
    var embeddedSignIn: UserSignInViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        containerForUser.alpha = 1
        containerForSignIn.alpha = 0
        // Do any additional setup after loading the view.
    }
    
    
    func showForUser() {
        containerForUser.alpha = 1
        containerForSignIn.alpha = 0
        embeddedSettings.updateUI()
    }
    
    func showForSignIn() {
        containerForUser.alpha = 0
        containerForSignIn.alpha = 1
        embeddedSignIn.cleanFields()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        User.checkLogin(false, vc: self) ? showForUser() : showForSignIn()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Get container view controllers 

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let vc = segue.destinationViewController as? SettingsTableViewController {
            self.embeddedSettings = vc
        }
        if let vc = segue.destinationViewController as? UserSignInViewController {
            self.embeddedSignIn = vc
        }
    }

}
