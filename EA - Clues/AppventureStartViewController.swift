//
//  Alt1AppventureStartViewController.swift
//  EA - Clues
//
//  Created by James Birtwell on 04/02/2016.
//  Copyright © 2016 James Birtwell. All rights reserved.
//

import Parse
import UIKit




class AppventureStartViewController: UIViewController {
    
    struct Constants {
        static let segueToStep = "StepSegue"
        static let CellID = "Cell"
    }
    
    lazy var appventure = Appventure()
    var completedAppventures = [CompletedAppventure]()
    var reviews = [String]()

    @IBOutlet weak var startAppventure: UIButton!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var appventureTitle: UILabel!
    @IBOutlet weak var duration: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var startingLocation: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var detailsSegmentControl: UISegmentedControl!
    @IBOutlet weak var keyFeaturesLabel: UILabel!
    @IBOutlet weak var restrictionsLabel: UILabel!
    
    @IBOutlet weak var detailsView: UIView!


  
    //MARK: Controller Lifecyele
    override func viewDidLoad() {
        updateUI()
        startButton.enabled = false
        startButton.alpha = 0.5
       detailsSegmentControl.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Palatino", size: 15)!], forState: UIControlState.Normal) //, NSForegroundColorAttributeName:UIColor.whiteColor()
        detailsSegmentControl.selectedSegmentIndex = 0
        AppventureStep.loadSteps(appventure, vc: self)
        CompletedAppventure.loadAppventuresCompleted(appventure.PFObjectID!, handler: self)
        AppventureReviews.loadAppventuresReviews(appventure.PFObjectID!, handler: self)
        
    }
    
    func updateUI () {
        
        self.appventureTitle.text = appventure.title
        descriptionLabel.text = appventure.subtitle!
        self.startingLocation.text = self.appventure.startingLocationName
        
        appventure.keyFeatures.count == 0 ? (self.keyFeaturesLabel.text = "None") : (self.keyFeaturesLabel.text = self.appventure.keyFeatures.joinWithSeparator(", "))
        appventure.restrictions.count == 0 ? (self.restrictionsLabel.text = "None") : (self.restrictionsLabel.text = self.appventure.restrictions.joinWithSeparator(", "))
        
        imageView.image = halfImage(appventure.image!)
        duration.text = appventure.duration
        startButton.layer.borderWidth = 1.5
        startButton.layer.borderColor = UIColor.whiteColor().CGColor
    }
    
    
    //MARK: Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Constants.segueToStep {
            if let svc = segue.destinationViewController as? StepViewController {
                svc.appventure = self.appventure
                svc.completedAppventures = self.completedAppventures
            }
        }
    }
    
    @IBAction func popController(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    //MARK: IBActions
   
    
    @IBAction func detialsSegmentUpdate(sender: UISegmentedControl) {
        switch detailsSegmentControl.selectedSegmentIndex {
        case 0:
            view.bringSubviewToFront(detailsView)
        case 1:
            view.bringSubviewToFront(tableView)
            tableView.reloadData()
        case 2:
            view.bringSubviewToFront(tableView)
            tableView.reloadData()
        default: break
        }
    }
    
    //MARK: Image Function
    func halfImage(image: UIImage) -> UIImage? {
        if let halfImage = CGImageCreateWithImageInRect(image.CGImage, CGRectMake(0, 0, image.size.width, image.size.height / 2.0)) as CGImageRef! {
            return UIImage(CGImage: halfImage)
        }
        return nil
    }
    
}

extension AppventureStartViewController : ParseQueryHandler {
    
     func handleQueryResults(objects: [PFObject]?, handlerCase: String?) {
        switch handlerCase! {
        case AppventureReviews.appventureReviewsHC:
            reviews.removeAll()
            for object in objects! {
                let review = object.objectForKey(AppventureReviews.parseCol.review) as! String
                reviews.append(review)
            }
            tableView.reloadData()
        case CompletedAppventure.allCompletedHC:
            completedAppventures.removeAll()
            for object in objects! {
                let completdAppventure = CompletedAppventure(object: object)
                completedAppventures.append(completdAppventure)
            }
            completedAppventures.sortInPlace({ $0.time < $1.time })
            tableView.reloadData()
        case AppventureStep.appventureStepsHc:
            HelperFunctions.loadAllData(appventure)
            if appventure.appventureSteps.count == 0 {
                startAppventure.enabled = false
            } else {
                startAppventure.enabled = true
                startButton.alpha = 1
                
            }
        default:
            break
        }
        
    }
    

    @IBAction func tapForDirections(sender: UITapGestureRecognizer) {
        openMapLocation(sender)
    }
    
    func openMapLocation(sender: AnyObject) {
        HelperFunctions.openMaps("Shoreditch, London", vc: self)
    }
    
}

extension AppventureStartViewController : UITableViewDataSource, UITableViewDelegate {
    

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        switch detailsSegmentControl.selectedSegmentIndex {
        case 1:
            if self.completedAppventures.count > 0 {
                self.tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
                self.tableView.backgroundView = UIView()
                return 1
            } else {
                let message = "No one has completed this appventure yet. Be the first!"
                HelperFunctions.noTableDataMessage(tableView, message: message)
            }
            return 0
        case 2:
            if self.reviews.count > 0 {
                self.tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
                self.tableView.backgroundView = UIView()
                return 1
            } else {
                let message = "No one has reviewed this appventure yet."
                HelperFunctions.noTableDataMessage(tableView, message: message)
            }
            return 0
        default:
            break
        }
        return 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if detailsSegmentControl.selectedSegmentIndex == 1 {
            return self.completedAppventures.count
        } else  {
            return self.reviews.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
 
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.CellID) as UITableViewCell!
        
        switch detailsSegmentControl.selectedSegmentIndex {
        case 1 :
            cell.textLabel?.text = completedAppventures[indexPath.row].teamName
            let tString = HelperFunctions.formatTime(completedAppventures[indexPath.row].time, nano: false)
            cell.detailTextLabel?.text = tString!
        case 2 :
            cell.textLabel?.text = reviews[indexPath.row]
            cell.detailTextLabel?.text = ""

        default : break
        }
        
        return cell
    }
}


