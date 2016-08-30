//
//  LocationSettingsTableViewController.swift
//  EA - Clues
//
//  Created by James Birtwell on 01/02/2016.
//  Copyright © 2016 James Birtwell. All rights reserved.
//

import UIKit

class LocationSettingsTableViewController: UITableViewController {
    
    struct Constants {
        static let backImage = "BackButton"
    }
    
    lazy var step = AppventureStep()

    @IBOutlet weak var showLocation: UISwitch!
    @IBOutlet weak var showCompass: UISwitch!
    @IBOutlet weak var showDistance: UISwitch!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if step.setup[AppventureStep.setup.locationShown]! == true {
            showLocation.on = true
        }
        if step.setup[AppventureStep.setup.compassShown]! == true {
            showCompass.on = true
        }
        if step.setup[AppventureStep.setup.distanceShown]! == false {
            showDistance.on = false
        }
        
        
   }

    @IBAction func backButton(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func updateShowLocation(sender: UISwitch) {
        step.setup[AppventureStep.setup.locationShown] = showLocation.on
    }
    @IBAction func updateShowCompass(sender: AnyObject) {
        step.setup[AppventureStep.setup.compassShown] = showLocation.on
    }
    @IBAction func updateShowDistance(sender: UISwitch) {
        step.setup[AppventureStep.setup.distanceShown] = showLocation.on
    }
    
   
}
