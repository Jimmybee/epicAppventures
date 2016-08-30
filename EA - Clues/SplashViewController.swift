//
//  SplashViewController.swift
//  EA - Clues
//
//  Created by James Birtwell on 07/02/2016.
//  Copyright © 2016 James Birtwell. All rights reserved.
//

import UIKit
import Parse

class SplashViewController: UIViewController {
    
    var appventuresArr = [Appventure]()
    
    struct Constants {
        static let LocalAppventuresSegue = "LocalAppventuresSegue"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let london = CLLocationCoordinate2D(latitude: 51.5072, longitude: 0.1275)
        Appventure.loadLocationAppventure(london, handler: self)


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let a1lavc = segue.destinationViewController as? LocalTableViewController {
            a1lavc.appventuresArr = self.appventuresArr
        }
    }

}

extension SplashViewController : ParseQueryHandler {
    func handleQueryResults(objects: [PFObject]?, handlerCase: String?) {
        if let isPFArray = objects as [PFObject]! {
            for object in isPFArray {
                let appventure = Appventure(object: object)
                let appventureLocation = CLLocation(latitude: appventure.coordinate!.latitude, longitude: appventure.coordinate!.longitude)
//                if let gotLocation = lastLocation as CLLocation! {
//                    appventure.distanceToSearch = gotLocation.distanceFromLocation(appventureLocation)
//                }
                self.appventuresArr.append(appventure)
            }
        }
        performSegueWithIdentifier(Constants.LocalAppventuresSegue, sender: self)
        
    }
}
