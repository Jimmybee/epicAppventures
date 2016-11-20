//
//  Alt1AppventureStartViewController.swift
//  EA - Clues
//
//  Created by James Birtwell on 04/02/2016.
//  Copyright © 2016 James Birtwell. All rights reserved.
//

//import Parse
import UIKit




class AppventureStartViewController: UIViewController {
    
    struct Constants {
        static let StartAdventureSegue = "StartAdventure"
        static let CellID = "Cell"
    }
    
    lazy var appventure = Appventure()
    var completedAppventures = [CompletedAppventure]()
    var reviews = [String]()

//    @IBOutlet weak var startAppventure: UIButton!
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
       detailsSegmentControl.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Palatino", size: 15)!], forState: UIControlState.Normal) //, NSForegroundColorAttributeName:UIColor.whiteColor()
        detailsSegmentControl.selectedSegmentIndex = 0
        CompletedAppventure.loadAppventuresCompleted(appventure.pFObjectID!, handler: self)
        AppventureReviews.loadAppventuresReviews(appventure.pFObjectID!, handler: self)
        HelperFunctions.hideTabBar(self)

        
    }
    
   
    
    func updateUI () {
        self.navigationItem.title = appventure.title
        self.appventureTitle.text = appventure.title
        descriptionLabel.text = appventure.subtitle!
        self.startingLocation.text = self.appventure.startingLocationName
        
        appventure.keyFeatures.count == 0 ? (self.keyFeaturesLabel.text = "None") : (self.keyFeaturesLabel.text = self.appventure.keyFeatures.joinWithSeparator(", "))
        appventure.restrictions.count == 0 ? (self.restrictionsLabel.text = "None") : (self.restrictionsLabel.text = self.appventure.restrictions.joinWithSeparator(", "))
        
        imageView.image = halfImage(appventure.image!)
        duration.text = appventure.duration
        if self.appventure.downloaded == true {
            startButton.setTitle("Play", forState: .Normal)
        }
    }
    
    //MARK: Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Constants.StartAdventureSegue {
            if let svc = segue.destinationViewController as? StepViewController {
                svc.appventure = self.appventure
                svc.completedAppventures = self.completedAppventures
            }
        }
    }
    
    @IBAction func menuPopUp(sender: AnyObject) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Remove Downloaded Content", style: .Default, handler: { action in
            if self.appventure.userID != User.user?.pfObject {
                self.appventure.deleteFromContext({
                    dispatch_async(dispatch_get_main_queue()) { () -> Void in
                        let completedRemoval = UIAlertController(title: "Removed", message: "Delete this appventure from your maker profile.", preferredStyle: UIAlertControllerStyle.Alert)
                        completedRemoval.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                        self.presentViewController(completedRemoval, animated: true, completion: nil)
                    }
                })
            } else {
                self.appventure.liveStatus = LiveStatus.inDevelopment
                self.appventure.saveAndSync()
                self.appventure.completeSaveToContext({
                    dispatch_async(dispatch_get_main_queue()) { () -> Void in
                        let ownedAlert = UIAlertController(title: "Locally Created", message: "Appventure set to in development. Delete this appventure from your maker profile.", preferredStyle: UIAlertControllerStyle.Alert)
                        ownedAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default , handler: nil))
                        self.presentViewController(ownedAlert, animated: true, completion: nil)
                    }
                })
            }
        }))

        self.presentViewController(alert, animated: true, completion: nil)
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
    
    @IBAction func downloadAdventure(sender: AnyObject) {
        if appventure.downloaded == true {
            performSegueWithIdentifier(Constants.StartAdventureSegue, sender: nil)
        } else {
            appventure.downloadAndSaveToCoreData(downloadComplete)
        }
    }
    
    func downloadComplete() {
        self.appventure.downloaded = true
        self.startButton.setTitle("Play", forState: .Normal)
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
    
     func handleQueryResults(objects: [AnyObject]?, handlerCase: String?) {
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


