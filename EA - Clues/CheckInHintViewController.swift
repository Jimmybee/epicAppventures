//
//  CheckInHintViewController.swift
//  EA - Clues
//
//  Created by James Birtwell on 10/02/2016.
//  Copyright © 2016 James Birtwell. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlacePicker

class CheckInHintViewController: UIViewController {
    
    lazy var stepLocationName = ""
    lazy var stepCoordinate = kCLLocationCoordinate2DInvalid
    lazy var lastLocation = CLLocation()
    lazy var stepDistance = 0
    lazy var stepHint = ""
    var answerHint = [String]()
    var hintsRecieved = 0
    
    
    @IBOutlet weak var hintButton: UIButton!
    
    
    var placePicker: GMSPlacePicker?
    
//    @IBOutlet weak var hint: UILabel!
    @IBOutlet weak var checkIn: UIButton!
//    @IBOutlet weak var revealButton: UIButton!
    @IBOutlet weak var warningLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkIn.layer.borderWidth = 2.0
        checkIn.layer.borderColor = UIColor.whiteColor().CGColor
        hintButton.layer.borderWidth = 2.0
        hintButton.layer.borderColor = UIColor.whiteColor().CGColor
        // Do any additional setup after loading the view.
    }
    
    func setup () {
        warningLabel.text = ""
         hintsRecieved = 0

    }

    //MARK: Check In Method
    @IBAction func checkIn(sender: UIButton) {
        var center: CLLocationCoordinate2D?
        
        if let currentCoordinate = lastLocation.coordinate as CLLocationCoordinate2D! {
            center = CLLocationCoordinate2DMake(currentCoordinate.latitude, currentCoordinate.longitude)
        } else {
            center = CLLocationCoordinate2DMake(0, 0)
        }
        
        let northEast = CLLocationCoordinate2DMake(center!.latitude + 0.001, center!.longitude + 0.001)
        let southWest = CLLocationCoordinate2DMake(center!.latitude - 0.001, center!.longitude - 0.001)
        
        let viewport = GMSCoordinateBounds(coordinate: northEast, coordinate: southWest)

        let config = GMSPlacePickerConfig(viewport: viewport)
        placePicker = GMSPlacePicker(config: config)
        
        placePicker?.pickPlaceWithCallback({ (place: GMSPlace?, error: NSError?) -> Void in
            if let error = error {
                print("Pick Place error: \(error.localizedDescription)")
                return
            }
            if let place = place {
                if place.name == self.stepLocationName {
                    let placeCenter = CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
                    let distanceToPlace = placeCenter.distanceFromLocation(self.lastLocation)
                    print(self.lastLocation.coordinate)
                    print(placeCenter.coordinate)
                    print(distanceToPlace)
                    if self.stepDistance == 0 ||  distanceToPlace < Double(self.stepDistance) {
                        if let pvc = self.parentViewController as? StepViewController {
                            pvc.stepComplete()
                        }
                    } else {
                        self.warningLabel.text = "Move closer to the destination to proceed."
                    }
                    
                } else {
                    print(self.stepLocationName)
                    self.warningLabel.text = "Incorrect place selected. Try Again."
                }
            } else {
                print("No place selected")
            }
        })
        
    }
    
    @IBAction func revealHint(sender: UIButton) {
        if self.answerHint.count == self.hintsRecieved {
            let alert = UIAlertController(title: "No Hints", message: "There are no hints remaining.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler: nil))
            
            self.presentViewController(alert, animated: true, completion: nil)
            
        } else {
            
            let alert = UIAlertController(title: "Get Hint", message: "Getting a hint may incur a time penalty. There are \( self.answerHint.count - self.hintsRecieved) hints remaining.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Confirm", style: UIAlertActionStyle.Default, handler: { action in
                if let pvc = self.parentViewController as? StepViewController{
                    pvc.updateHintText(self.answerHint[self.hintsRecieved], hintsRecieved: self.hintsRecieved)
                    self.hintsRecieved += 1

                }
            }))
            
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
//
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
