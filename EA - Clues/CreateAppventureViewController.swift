//
//  CreateAppViewController.swift
//  MapPlay
//
//  Created by James Birtwell on 18/12/2015.
//  Copyright © 2015 James Birtwell. All rights reserved.
//

import UIKit
import MapKit
import Parse
import GoogleMaps

protocol CreateAppventureViewControllerDelegate: NSObjectProtocol {
    
    func appendNewAppventure(appventure: Appventure, indexRow: Int?)
    func reloadTable()
}

class CreateAppventureViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate {
    
    struct Constants {
        static let cellName = "StepCell"
        static let placeholderText  = "Add New"
        static let segueNewStep = "Add New Step"
        static let segueAddStepCancel = "Cancel Add Step"
        static let editAppventureDetailsSegue = "Edit Appventure Details"
        static let newTitle = "new"
        static let shareWithFriend = "shareWithFriend"
    }
    
//    Model
    var newAppventure: Appventure!
    var delegate: CreateAppventureViewControllerDelegate?
    
    lazy var appventureIndexRow = 999
    
    var userID: String?
    var lastLocation: CLLocation?
    var mapMarkers = [GMSMarker]()
    
    //Process Elements
    var locationManager = CLLocationManager()
    
    //MARK: Outlets
    //Views
    @IBOutlet weak var stepsContainer: UIView!
    @IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var containerView: UIView!
    //Constraints
    @IBOutlet weak var stepsTopSegmentBottomCon: NSLayoutConstraint!
    @IBOutlet weak var stepsHeight: NSLayoutConstraint!
    
    @IBOutlet weak var mapBottomSegmentBottom: NSLayoutConstraint!
    @IBOutlet weak var mapBottomLayoutBottom: NSLayoutConstraint!
    
    @IBOutlet weak var detailsEqualSuperHeight: NSLayoutConstraint! // startsInactive
    @IBOutlet weak var detailsEqualSegmentControlBottom: NSLayoutConstraint! //detailsTop - starts active
    @IBOutlet weak var detailsBottomLayoutBottom: NSLayoutConstraint! //startsActive
    @IBOutlet weak var detailsTopEqualLayoutBottom: NSLayoutConstraint! //startsInactive
    @IBOutlet weak var developLocalPublicControl: UISegmentedControl! 
    
    func detailsUp () {
        detailsBottomLayoutBottom.active = true
        detailsEqualSegmentControlBottom.active = true
        detailsTopEqualLayoutBottom.active = false
        detailsEqualSuperHeight.active = false
    }
    
    func detailsDown() {
        detailsBottomLayoutBottom.active = false
        detailsEqualSegmentControlBottom.active = false
        detailsTopEqualLayoutBottom.active = true
        detailsEqualSuperHeight.active = true
    }
    
    //UI Control
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    //Labels
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var startingPositionLabel: UILabel!
//    @IBOutlet weak var tagsLabel: UILabel!
  
    @IBOutlet weak var shareButton: UIButton!


//    MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shareButton.layer.borderWidth = 1.5
        shareButton.layer.borderColor = UIColor.whiteColor().CGColor
        
        HelperFunctions.hideTabBar(self)
        
        if newAppventure == nil {
            //popup for name
            newAppventure = Appventure()
            User.user?.ownedAppventures.append(newAppventure)
            newAppventure!.saveToParse()
            setupForNewAppventure()
            performSegueWithIdentifier(Constants.editAppventureDetailsSegue, sender: nil)

        } else {
//            AppventureStep.loadSteps(newAppventure!, handler: stepsLoaded)
            updateUI()
        }

        //Location Manager
        self.locationManager.delegate = self
        getQuickLocationUpdate()
        
        //Set default edit button action
        editButton.title = "Edit"
//        editButton.action = "editDetailsSegue:"
//        editButton.action = #selector(CreateAppventureViewController.editDetailsSegue(_:))
    
    }
    
    func stepsLoaded(){
        tableView.reloadData()
    }
    
    func setupForNewAppventure() {

    }

    @IBAction func shareWithFriends(sender: AnyObject) {
        if User.user?.facebookConnected == true {
            performSegueWithIdentifier(Constants.shareWithFriend, sender: nil)
        } else {
            let alert = UIAlertController(title: "Share", message: "Log in with facebook to share.", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        
        self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        updateUI()
        if newAppventure!.appventureSteps.count > 0 {
            if CLLocationCoordinate2DIsValid(newAppventure!.appventureSteps[0].coordinate) {
                newAppventure!.coordinate = newAppventure!.appventureSteps[0].coordinate
                drawMap()
            }
        }
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Map Location & Map Drawing
    func drawMap() {
        
        if let isAppventure = newAppventure {
        let lat = isAppventure.appventureSteps[0].coordinate.latitude
        let long = isAppventure.appventureSteps[0].coordinate.longitude
        
        var top =  lat + 0.01
        var left =  long - 0.01
        var bottom = lat - 0.01
        var right = long + 0.01
        var totalDistance = 0.0
        var previousLocation = CLLocation(latitude: lat, longitude: long)
        
        var bounds = GMSCoordinateBounds?()
        self.mapMarkers.removeAll()
        for step in isAppventure.appventureSteps {
            let marker = GMSMarker(position: step.coordinate)
            marker.title = ("\(step.stepNumber): \(step.nameOrLocation)")
            marker.snippet = step.locationSubtitle
            marker.map = self.mapView
            mapMarkers.append(marker)
            
            if marker.position.latitude > top { top = marker.position.latitude }
            if marker.position.latitude < bottom { bottom = marker.position.latitude }
            if marker.position.longitude > right { right = marker.position.longitude }
            if marker.position.longitude < left { left = marker.position.longitude }
            
            let northEast = CLLocationCoordinate2DMake(top, right)
            let southWest = CLLocationCoordinate2DMake(bottom, left)
             bounds = GMSCoordinateBounds(coordinate: northEast, coordinate: southWest)
            
            //distance calculation
            let currentLocation = CLLocation(latitude: step.coordinate.latitude, longitude: step.coordinate.longitude)
            totalDistance = totalDistance + currentLocation.distanceFromLocation(previousLocation)
            previousLocation = currentLocation
        }
        
        isAppventure.totalDistance = totalDistance
            let upD = GMSCameraUpdate.setTarget(isAppventure.appventureSteps[0].coordinate, zoom: 12.0)
//        let update = GMSCameraUpdate.fitBounds(bounds!)
            
        mapView.moveCamera(upD)
        
        }
        
    }
    
    func getQuickLocationUpdate() {
//        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lastLocation = locations.last
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        
    }

    
    //MARK: UI Interface
    
    func updateUI () {
        
        self.navigationItem.title = newAppventure.title
        imageView.image = newAppventure.image
        nameLabel.text =  newAppventure.title
        descriptionLabel.text = newAppventure.subtitle
        durationLabel.text = newAppventure.duration
        startingPositionLabel.text = newAppventure.startingLocationName
        tableView.reloadData()
//        newAppventure.liveStatus == .inDevelopment ? (liveStatusSwitch.on = false) : (liveStatusSwitch.on = true)
        //segmented control
        if newAppventure.liveStatus.segmentValue() == 3 {
            self.developLocalPublicControl.selectedSegmentIndex = 2
            if let dlps = developLocalPublicControl as? DevelopLocalPublicSegmented {
                dlps.setToLive()
            }
        } else {
            self.developLocalPublicControl.selectedSegmentIndex = newAppventure.liveStatus.segmentValue()
        }
        self.segmentControl.layer.cornerRadius = 15.0;
        self.segmentControl.layer.borderColor = UIColor.whiteColor().CGColor
        self.segmentControl.layer.borderWidth = 1.0
        self.segmentControl.layer.masksToBounds = true
        stylizeFonts()
        
        

    }
    
    func stylizeFonts(){
        let normalFont = UIFont(name: "Helvetica", size: 16.0)
        let boldFont = UIFont(name: "Helvetica-Bold", size: 16.0)
        
        let normalTextAttributes: [NSObject : AnyObject] = [
            NSForegroundColorAttributeName: UIColor.darkGrayColor(),
            NSFontAttributeName: normalFont!
        ]
        
        let boldTextAttributes: [NSObject : AnyObject] = [
            NSForegroundColorAttributeName : UIColor.darkGrayColor(),
            NSFontAttributeName : boldFont!,
            ]
        
        self.segmentControl.setTitleTextAttributes(normalTextAttributes, forState: .Normal)
        self.segmentControl.setTitleTextAttributes(normalTextAttributes, forState: .Highlighted)
        self.segmentControl.setTitleTextAttributes(boldTextAttributes, forState: .Selected)
    }
    
    
    //MARK: IB Actions
    
    
    @IBAction func statusSegmentChange(sender: UISegmentedControl) {
        let message = goodForLive()

        func revertToDevelop() {
            self.newAppventure.liveStatus = .inDevelopment
            sender.selectedSegmentIndex = 0
            let fullMessage = "Complete the " + message
            let alert = UIAlertController(title: nil, message: fullMessage, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
        }
        
        func tryForPublic() {
            self.newAppventure.liveStatus = .waitingForApproval
            let alert = UIAlertController(title: "Public Adventure", message: "This adventure will be looked at by one of our team, and if suitable made available to everyone.", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))

        
        self.presentViewController(alert, animated: true, completion: nil)
        }
        
        
        switch sender.selectedSegmentIndex {
        case 0:
            self.newAppventure.liveStatus = .inDevelopment
        case 1:
            message == "" ? (self.newAppventure.liveStatus = .local) : (revertToDevelop())
        case 2:
            message == "" ? (tryForPublic()) : (revertToDevelop())
        default:
            break
        }
        
        self.newAppventure.saveToParse()
    }
    
    
    func goodForLive() -> String {
        var message = [String]()
        if self.newAppventure.startingLocationName!.characters.count == 0 { message.append("Starting Location") }
        if self.newAppventure.subtitle!.characters.count == 0 { message.append("Description") }
        if self.newAppventure.title!.characters.count == 0 { message.append("Name") }
        if self.newAppventure.appventureSteps.count == 0 { message.append("Steps") }
        let fullMessage = message.joinWithSeparator(", ")
        return fullMessage
    }
    
    @IBAction func updateSegment(sender: UISegmentedControl) {
        let controlValue = sender.selectedSegmentIndex
        switch controlValue {
        case 0:
            detailsView.hidden = false
            editButton.title = "Edit"
            editButton.enabled = true
//                        editButton.action = "editDetailsSegue"
//            editButton.action = #selector(CreateAppventureViewController.editDetailsSegue(_:))
            
            self.containerView.bringSubviewToFront(detailsView)
            tableView.setEditing(false , animated: true)

            UIView.animateWithDuration(0.3, animations: {
                self.stepsTopSegmentBottomCon.active = false
                self.stepsHeight.active = true
                self.mapBottomLayoutBottom.active = false
                self.mapBottomSegmentBottom.active = true
                self.detailsUp()
                self.view.layoutIfNeeded()
                })

        case 1:
            stepsContainer.hidden = false
            editButton.enabled = true
            editButton.title = "Edit"
//            editButton.action = "editStepTable:"
//            editButton.action = #selector(CreateAppventureViewController.editStepTable(_:))
            self.containerView.bringSubviewToFront(stepsContainer)
            
            UIView.animateWithDuration(0.3, animations: {
                self.stepsTopSegmentBottomCon.active = true
                self.stepsHeight.active = false
                self.detailsDown()

                self.mapBottomLayoutBottom.active = false
                self.mapBottomSegmentBottom.active = true
                self.view.layoutIfNeeded()
                })
            
            
        
        case 2:
            
            tableView.setEditing(false , animated: true)

            editButton.enabled = false
            editButton.title = nil
            mapView.hidden = false
            UIView.animateWithDuration(0.3, animations: {
                self.stepsTopSegmentBottomCon.active = false
                self.stepsHeight.active = true
                self.detailsDown()
                self.mapBottomLayoutBottom.active = true
                self.mapBottomSegmentBottom.active = false
                self.view.layoutIfNeeded()
                })
        default: break
        }
        
    }
    
    //Edit Actions 
    
    func editStepTable(sender: AnyObject) {
        editButton.title = "Done"
//        editButton.action = "doneEditStepTable:"
//        editButton.action = #selector(self.doneEditStepTable(_:))
        tableView.setEditing(true, animated: true)
        segmentControl.enabled = false
    }
    
    func doneEditStepTable(sender: AnyObject) {
        editButton.title = "Edit"
//        editButton.action = "editStepTable:"

//        editButton.action = #selector(self.editStepTable(_:))
        tableView.setEditing(false , animated: true)
        segmentControl.enabled = true
        tableView.reloadData()

    }
    
    func editDetailsSegue() {
        performSegueWithIdentifier(Constants.editAppventureDetailsSegue, sender: self)
    }
    
    
//MARK: Navigation
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        if self.newAppventure.title == Constants.newTitle {
            self.newAppventure.deleteAppventure()
            self.navigationController?.popViewControllerAnimated(true)
        }
        
        self.navigationController?.popViewControllerAnimated(true)

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == Constants.segueNewStep {
            if let tbCell = sender as? AppventureStepTableViewCell {
                if let indexPath = tableView.indexPathForCell(tbCell)?.row as Int! {
                    if let nvc = segue.destinationViewController as? UINavigationController {
                    if let asvc = nvc.childViewControllers[0] as? AddStepTableViewController {
                        if newAppventure.appventureSteps.count > indexPath {
                            let appventureStep = newAppventure.appventureSteps[indexPath]
                            asvc.currentStep = appventureStep
                            asvc.editOfCurrentStep = true
                        } else {
                            asvc.appventureStep.stepNumber = newAppventure.appventureSteps.count + 1
                            asvc.appventureStep.appventurePFObjectID = newAppventure.pFObjectID
                        }
                        asvc.lastLocation = self.lastLocation
                        asvc.delegate = self
                        }
                    }
                }
            }
        }
        
        if segue.identifier == Constants.editAppventureDetailsSegue {
            if let nvc = segue.destinationViewController as? UINavigationController {
                if let eadvc = nvc.childViewControllers[0] as? EditAppventureDetailsTableViewController {
                    eadvc.appventure = self.newAppventure
                }
            }
        }
        
        if segue.identifier == Constants.shareWithFriend{
            if let nvc = segue.destinationViewController as? UINavigationController {
                if let ftvc = nvc.childViewControllers[0] as? FriendsTableViewController {
                    ftvc.appventure = self.newAppventure
                }
            }
        }
    }
    
    
    //MARK: Table functions
    

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if CLLocationCoordinate2DIsValid(newAppventure.coordinate!) {
            return newAppventure.appventureSteps.count + 1
        } else {
            return 1
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.cellName) as! AppventureStepTableViewCell
        
        let row = indexPath.row
        
        if row < newAppventure.appventureSteps.count  {
            if let step = newAppventure.appventureSteps[row] as AppventureStep! {
                cell.StepID.text = "Step: \(step.stepNumber) \(step.nameOrLocation)"
                var includedClues = [String]()
                if step.setup[AppventureStep.setup.pictureClue] == true {includedClues.append("Picture")}
                if step.setup[AppventureStep.setup.textClue] == true {includedClues.append("Text")}
                if step.setup[AppventureStep.setup.soundClue] == true {includedClues.append("Sound Clip")}
                cell.shortDescription.text = "Clues: \(includedClues.joinWithSeparator(","))"
                
                if step.setup[AppventureStep.setup.checkIn] == true {
                    cell.answer.text = "Check In"}
                else {
                    cell.answer.text = "Text Answer"}
                
                
                if step.saved == false {
                    newAppventure.saved = false
                }
                
            }
        } else {
            cell.StepID.text = Constants.placeholderText
            cell.shortDescription.text = ""
            cell.answer.text = ""
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            confirmDeletePopup(indexPath)
        }
    }
    
    func confirmDeletePopup (indexPath: NSIndexPath) {
        let alert = UIAlertController(title: "Delete Step?", message: "Step data will be lost!", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Destructive, handler: { action in
            self.deleteStepFromDB(indexPath)
            self.newAppventure.appventureSteps.removeAtIndex(indexPath.row)
            self.tableView.reloadData()
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func deleteStepFromDB(indexPath: NSIndexPath) {
        let objectID = newAppventure.appventureSteps[indexPath.row].pFObjectID
        let query = PFQuery(className: AppventureStep.pfStep.pfClass)
        query.getObjectInBackgroundWithId(objectID!) {
            (object: PFObject?, error: NSError?) -> Void in
            if error != nil {
                print(error)
            } else {
                object?.deleteInBackground()
            }
        }

    }

    // Determine whether a given row is eligible for reordering or not.
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool
    {
        return true;
    }
    
    // Process the row move. This means updating the data model to correct the item indices.
    func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath)
    {
        let step = newAppventure.appventureSteps[sourceIndexPath.row];
        newAppventure.appventureSteps.removeAtIndex(sourceIndexPath.row);
        newAppventure.appventureSteps.insert(step, atIndex: destinationIndexPath.row)
    
    
        for step in newAppventure.appventureSteps {
            step.stepNumber = newAppventure.appventureSteps.indexOf(step)! + 1
        }
    }
    
}


extension CreateAppventureViewController : AddStepTableViewControllerDelegate {
    
    func appendStep(step: AppventureStep, stepNumber: Int16?) {
        if let number = stepNumber as Int16! {
            newAppventure.appventureSteps[number - 1] = step
        } else {
            newAppventure.appventureSteps.append(step)
        }
        tableView.reloadData()
        
        print("reload step table")
    }
    
    func updateAppventureLocation(location: CLLocationCoordinate2D) {
        self.newAppventure.coordinate = location
    }
}

extension CreateAppventureViewController : ParseQueryHandler {
    
    func handleQueryResults(_: [PFObject]?, handlerCase: String?) {
        self.newAppventure.downloadAndSaveToCoreData(downloadComplete)
    }
    
    func downloadComplete() {
        
    }
}

extension CreateAppventureViewController : EditAppventureDetailsTableViewControllerDelegate {
    
    func completedEdit(appventure: Appventure) {
        
    }
//    func completedEdit (edittedAppventure: Appventure) {
//        newAppventure = Appventure(appventure: edittedAppventure)
//        if newAppventure.liveStatus == .live { newAppventure.liveStatus = .waitingForApproval}
//        newAppventure.save()
//        updateUI()
//        if appventureIndexRow == 999 {
//            delegate?.appendNewAppventure(newAppventure, indexRow: Int?())
//        } else {
//            delegate?.appendNewAppventure(newAppventure, indexRow: appventureIndexRow)
//        }
//    }
}



