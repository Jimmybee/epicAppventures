//
//  CreateAppViewController.swift
//  MapPlay
//
//  Created by James Birtwell on 18/12/2015.
//  Copyright © 2015 James Birtwell. All rights reserved.
//

import UIKit
import MapKit
//import Parse
import GoogleMaps

protocol CreateAppventureViewControllerDelegate: NSObjectProtocol {
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
    
//    @IBOutlet weak var mapBottomSegmentBottom: NSLayoutConstraint!
//    @IBOutlet weak var mapBottomLayoutBottom: NSLayoutConstraint!
    
    @IBOutlet weak var detailsEqualSuperHeight: NSLayoutConstraint! // startsInactive
    @IBOutlet weak var detailsEqualSegmentControlBottom: NSLayoutConstraint! //detailsTop - starts active
    @IBOutlet weak var detailsBottomLayoutBottom: NSLayoutConstraint! //startsActive
    @IBOutlet weak var detailsTopEqualLayoutBottom: NSLayoutConstraint! //startsInactive
    @IBOutlet weak var developLocalPublicControl: UISegmentedControl! 
    
    func detailsUp () {
        detailsBottomLayoutBottom.isActive = true
        detailsEqualSegmentControlBottom.isActive = true
        detailsTopEqualLayoutBottom.isActive = false
        detailsEqualSuperHeight.isActive = false
    }
    
    func detailsDown() {
        detailsBottomLayoutBottom.isActive = false
        detailsEqualSegmentControlBottom.isActive = false
        detailsTopEqualLayoutBottom.isActive = true
        detailsEqualSuperHeight.isActive = true
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
        shareButton.layer.borderColor = UIColor.white.cgColor
        
        HelperFunctions.hideTabBar(self)
        
        if newAppventure == nil {
            //popup for name
            newAppventure = Appventure()
            User.user?.ownedAppventures.append(newAppventure)
//            newAppventure!.saveAndSync()
            setupForNewAppventure()
            performSegue(withIdentifier: Constants.editAppventureDetailsSegue, sender: nil)

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

    @IBAction func shareWithFriends(_ sender: AnyObject) {
        if User.user?.facebookConnected == true {
            performSegue(withIdentifier: Constants.shareWithFriend, sender: nil)
        } else {
            let alert = UIAlertController(title: "Share", message: "Log in with facebook to share.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateUI()
        if newAppventure!.appventureSteps.count > 1 {
            if CLLocationCoordinate2DIsValid(newAppventure!.appventureSteps[0].location!.coordinate) {
                newAppventure!.location = newAppventure!.appventureSteps[0].location!
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
        let lat = isAppventure.appventureSteps[0].location!.coordinate.latitude
        let long = isAppventure.appventureSteps[0].location!.coordinate.longitude
        
        var top =  lat + 0.01
        var left =  long - 0.01
        var bottom = lat - 0.01
        var right = long + 0.01
        var totalDistance = 0.0
        var previousLocation = CLLocation(latitude: lat, longitude: long)
        
//        var bounds = GMSCoordinateBounds()
        self.mapMarkers.removeAll()
        for step in isAppventure.appventureSteps {
            let marker = GMSMarker(position: step.location!.coordinate)
            marker.title = ("\(step.stepNumber): \(step.nameOrLocation)")
            marker.snippet = step.locationSubtitle
            marker.map = self.mapView
            mapMarkers.append(marker)
            
            if marker.position.latitude > top { top = marker.position.latitude }
            if marker.position.latitude < bottom { bottom = marker.position.latitude }
            if marker.position.longitude > right { right = marker.position.longitude }
            if marker.position.longitude < left { left = marker.position.longitude }
            
//            let northEast = CLLocationCoordinate2DMake(top, right)
//            let southWest = CLLocationCoordinate2DMake(bottom, left)
//             bounds = GMSCoordinateBounds(coordinate: northEast, coordinate: southWest)
            
            //distance calculation
            let currentLocation = CLLocation(latitude: step.location!.coordinate.latitude, longitude: step.location!.coordinate.longitude)
            totalDistance = totalDistance + currentLocation.distance(from: previousLocation)
            previousLocation = currentLocation
        }
        
        isAppventure.totalDistance = totalDistance
            let upD = GMSCameraUpdate.setTarget(isAppventure.appventureSteps[0].location!.coordinate, zoom: 12.0)
//        let update = GMSCameraUpdate.fitBounds(bounds!)
            
        mapView.moveCamera(upD)
        
        }
        
    }
    
    func getQuickLocationUpdate() {
//        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lastLocation = locations.last
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
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
        self.segmentControl.layer.borderColor = UIColor.white.cgColor
        self.segmentControl.layer.borderWidth = 1.0
        self.segmentControl.layer.masksToBounds = true
        stylizeFonts()
        
        

    }
    
    func stylizeFonts(){
        let normalFont = UIFont(name: "Helvetica", size: 16.0)
        let boldFont = UIFont(name: "Helvetica-Bold", size: 16.0)
        
        let normalTextAttributes: [AnyHashable: Any] = [
            NSForegroundColorAttributeName: UIColor.darkGray,
            NSFontAttributeName: normalFont!
        ]
        
        let boldTextAttributes: [AnyHashable: Any] = [
            NSForegroundColorAttributeName : UIColor.darkGray,
            NSFontAttributeName : boldFont!,
            ]
        
        self.segmentControl.setTitleTextAttributes(normalTextAttributes, for: UIControlState())
        self.segmentControl.setTitleTextAttributes(normalTextAttributes, for: .highlighted)
        self.segmentControl.setTitleTextAttributes(boldTextAttributes, for: .selected)
    }
    
    
    //MARK: IB Actions
    
    
    @IBAction func statusSegmentChange(_ sender: UISegmentedControl) {
        let message = goodForLive()
        
        func revertToDevelop() {
            self.newAppventure.liveStatus = .inDevelopment
            sender.selectedSegmentIndex = 0
            let fullMessage = "Complete the " + message
            let alert = UIAlertController(title: nil, message: fullMessage, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
        
        func tryForPublic() {
            self.newAppventure.liveStatus = .waitingForApproval
            let alert = UIAlertController(title: "Public Adventure", message: "This adventure will be looked at by one of our team, and if suitable made available to everyone.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            
            
            self.present(alert, animated: true, completion: nil)
        }
        
        
        switch sender.selectedSegmentIndex {
        case 0:
            self.newAppventure.liveStatus = .inDevelopment
        case 1:
            message == "" ? (self.newAppventure.liveStatus = .local) : (revertToDevelop())
            BackendlessAppventure.save(appventure: newAppventure, withImage: true, completion: saveComplete)
        case 2:
            message == "" ? (tryForPublic()) : (revertToDevelop())
        default:
            break
        }
        
        AppDelegate.coreDataStack.saveContext(completion: nil)
        // TODO: Save to backend enabled for appventure.
//        self.newAppventure.
    }
    
    func saveComplete() {
        DispatchQueue.main.async {
            AppDelegate.coreDataStack.saveContext(completion: nil)
        }
    }
    
    
    func goodForLive() -> String {
        var message = [String]()
        if self.newAppventure.startingLocationName!.characters.count == 0 { message.append("Starting Location") }
        if self.newAppventure.subtitle!.characters.count == 0 { message.append("Description") }
        if self.newAppventure.title!.characters.count == 0 { message.append("Name") }
        if self.newAppventure.appventureSteps.count == 0 { message.append("Steps") }
        let fullMessage = message.joined(separator: ", ")
        return fullMessage
    }
    
    @IBAction func updateSegment(_ sender: UISegmentedControl) {
        let controlValue = sender.selectedSegmentIndex
        switch controlValue {
        case 0:
            detailsView.isHidden = false
            editButton.title = "Edit"
            editButton.isEnabled = true
//                        editButton.action = "editDetailsSegue"
//            editButton.action = #selector(CreateAppventureViewController.editDetailsSegue(_:))
            
            self.containerView.bringSubview(toFront: detailsView)
            tableView.setEditing(false , animated: true)

            UIView.animate(withDuration: 0.3, animations: {
                self.stepsTopSegmentBottomCon.isActive = false
                self.stepsHeight.isActive = true
//                self.mapBottomLayoutBottom.active = false
//                self.mapBottomSegmentBottom.active = true
                self.detailsUp()
                self.view.layoutIfNeeded()
                })

        case 1:
            stepsContainer.isHidden = false
            editButton.isEnabled = true
            editButton.title = "Edit"
//            editButton.action = "editStepTable:"
//            editButton.action = #selector(CreateAppventureViewController.editStepTable(_:))
            self.containerView.bringSubview(toFront: stepsContainer)
            
            UIView.animate(withDuration: 0.3, animations: {
                self.stepsTopSegmentBottomCon.isActive = true
                self.stepsHeight.isActive = false
                self.detailsDown()

//                self.mapBottomLayoutBottom.active = false
//                self.mapBottomSegmentBottom.active = true
                self.view.layoutIfNeeded()
                })
            
            
        
        case 2:
            
            tableView.setEditing(false , animated: true)

            editButton.isEnabled = false
            editButton.title = nil
            mapView.isHidden = false
            UIView.animate(withDuration: 0.3, animations: {
                self.stepsTopSegmentBottomCon.isActive = false
                self.stepsHeight.isActive = true
                self.detailsDown()
//                self.mapBottomLayoutBottom.active = true
//                self.mapBottomSegmentBottom.active = false
                self.view.layoutIfNeeded()
                })
        default: break
        }
        
    }
    
    //Edit Actions 
    
    func editStepTable(_ sender: AnyObject) {
        editButton.title = "Done"
//        editButton.action = "doneEditStepTable:"
//        editButton.action = #selector(self.doneEditStepTable(_:))
        tableView.setEditing(true, animated: true)
        segmentControl.isEnabled = false
    }
    
    func doneEditStepTable(_ sender: AnyObject) {
        editButton.title = "Edit"
//        editButton.action = "editStepTable:"

//        editButton.action = #selector(self.editStepTable(_:))
        tableView.setEditing(false , animated: true)
        segmentControl.isEnabled = true
        tableView.reloadData()

    }
    
    func editDetailsSegue() {
        performSegue(withIdentifier: Constants.editAppventureDetailsSegue, sender: self)
    }
    
    
//MARK: Navigation
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
      _ = self.navigationController?.popViewController(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == Constants.segueNewStep {
            if let tbCell = sender as? AppventureStepTableViewCell {
                if let indexPath = tableView.indexPath(for: tbCell)?.row as Int! {
                    if let nvc = segue.destination as? UINavigationController {
                    if let asvc = nvc.childViewControllers[0] as? AddStepTableViewController {
                        if newAppventure.appventureSteps.count > indexPath {
                            let appventureStep = newAppventure.appventureSteps[indexPath]
                            asvc.appventureStep = appventureStep
                        } else {
                            let appventureStep = AppventureStep(appventure: newAppventure)
                            appventureStep.stepNumber = Int16(newAppventure.appventureSteps.count)
                            appventureStep.appventurePFObjectID = newAppventure.backendlessId
                            asvc.appventureStep = appventureStep
                        }
                        asvc.lastLocation = self.lastLocation
                        asvc.delegate = self
                        }
                    }
                }
            }
        }
        
        if segue.identifier == Constants.editAppventureDetailsSegue {
            if let nvc = segue.destination as? UINavigationController {
                if let eadvc = nvc.childViewControllers[0] as? EditAppventureDetailsTableViewController {
                    eadvc.appventure = self.newAppventure
                }
            }
        }
        
        if segue.identifier == Constants.shareWithFriend{
            if let nvc = segue.destination as? UINavigationController {
                if let ftvc = nvc.childViewControllers[0] as? FriendsTableViewController {
                    ftvc.appventure = self.newAppventure
                }
            }
        }
    }
    
    
    //MARK: Table functions
    

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if CLLocationCoordinate2DIsValid(newAppventure.location.coordinate) {
            return newAppventure.appventureSteps.count + 1
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellName) as! AppventureStepTableViewCell
        let row = indexPath.row
        
        if row < newAppventure.appventureSteps.count  {
            if let step = newAppventure.appventureSteps[row] as AppventureStep! {
                
                cell.StepID.text = "Step: \(step.stepNumber) \(step.nameOrLocation!)"
                var includedClues = [String]()
                if step.setup.pictureClue == true {includedClues.append("Picture")}
                if step.setup.textClue == true {includedClues.append("Text")}
                if step.setup.soundClue == true {includedClues.append("Sound Clip")}
                cell.shortDescription.text = "Clues: \(includedClues.joined(separator: ","))"
                
                if step.setup.checkIn == true {
                    cell.answer.text = "Check In"}
                else {
                    cell.answer.text = "Text Answer"}
                
            }
        } else {
            cell.StepID.text = Constants.placeholderText
            cell.shortDescription.text = ""
            cell.answer.text = ""
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            confirmDeletePopup(indexPath)
        }
    }
    
    func confirmDeletePopup (_ indexPath: IndexPath) {
        let alert = UIAlertController(title: "Delete Step?", message: "Step data will be lost!", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.destructive, handler: { action in
            self.deleteStepFromDB(indexPath)
            self.newAppventure.appventureSteps.remove(at: indexPath.row)
            self.tableView.reloadData()
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func deleteStepFromDB(_ indexPath: IndexPath) {
//        let objectID = newAppventure.appventureSteps[indexPath.row].pFObjectID
//        let query = PFQuery(className: AppventureStep.pfStep.pfClass)
//        query.getObjectInBackgroundWithId(objectID!) {
//            (object: PFObject?, error: NSError?) -> Void in
//            if error != nil {
//                print(error)
//            } else {
//                object?.deleteInBackground()
//            }
//        }

    }

    // Determine whether a given row is eligible for reordering or not.
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool
    {
        return true;
    }
    
    // Process the row move. This means updating the data model to correct the item indices.
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath)
    {
        let step = newAppventure.appventureSteps[sourceIndexPath.row];
        newAppventure.appventureSteps.remove(at: sourceIndexPath.row);
        newAppventure.appventureSteps.insert(step, at: destinationIndexPath.row)
    
        for step in newAppventure.appventureSteps {
            step.stepNumber = newAppventure.appventureSteps.index(of: step)! + 1
        }
    }
    
}


extension CreateAppventureViewController : AddStepTableViewControllerDelegate {
    
    func updateAppventureLocation(_ location: CLLocation) {
        self.newAppventure.location = location
    }
}

extension CreateAppventureViewController : ParseQueryHandler {
    
    func handleQueryResults(_: [AnyObject]?, handlerCase: String?) {
        self.newAppventure.downloadAndSaveToCoreData(downloadComplete)
    }
    
    func downloadComplete() {
        
    }
}




