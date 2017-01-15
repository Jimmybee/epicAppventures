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
       detailsSegmentControl.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Palatino", size: 15)!], for: UIControlState()) //, NSForegroundColorAttributeName:UIColor.whiteColor()
        detailsSegmentControl.selectedSegmentIndex = 0
        //TODO: If a public appventure, then look for ratings and reviews.
//        CompletedAppventure.loadAppventuresCompleted(appventure.pFObjectID!, handler: self)
//        AppventureReviews.loadAppventuresReviews(appventure.pFObjectID!, handler: self)
        HelperFunctions.hideTabBar(self)
        
    }
    
   
    
    func updateUI () {
        self.navigationItem.title = appventure.title
        self.appventureTitle.text = appventure.title
        descriptionLabel.text = appventure.subtitle!
        self.startingLocation.text = self.appventure.startingLocationName
        
        appventure.keyFeatures?.count == 0 ? (self.keyFeaturesLabel.text = "None") : (self.keyFeaturesLabel.text = self.appventure.keyFeatures?.joined(separator: ", "))
        appventure.restrictions?.count == 0 ? (self.restrictionsLabel.text = "None") : (self.restrictionsLabel.text = self.appventure.restrictions?.joined(separator: ", "))
        
        imageView.image = halfImage(appventure.image!)
        duration.text = appventure.duration
        if self.appventure.downloaded == true {
            startButton.setTitle("Play", for: UIControlState())
        }
    }
    
    //MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.StartAdventureSegue {
            if let svc = segue.destination as? StepViewController {
                svc.appventure = self.appventure
                svc.completedAppventures = self.completedAppventures
            }
        }
    }
    
    @IBAction func menuPopUp(_ sender: AnyObject) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Remove Downloaded Content", style: .default, handler: { action in
            if self.appventure.userID != User.user?.pfObject {
                self.appventure.deleteFromContext({
                    DispatchQueue.main.async { () -> Void in
                        let completedRemoval = UIAlertController(title: "Removed", message: "Delete this appventure from your maker profile.", preferredStyle: UIAlertControllerStyle.alert)
                        completedRemoval.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                        self.present(completedRemoval, animated: true, completion: nil)
                    }
                })
            } else {
                self.appventure.liveStatus = LiveStatus.inDevelopment
//                self.appventure.saveAndSync()
//                self.appventure.completeSaveToContext({
//                    DispatchQueue.main.async { () -> Void in
//                        let ownedAlert = UIAlertController(title: "Locally Created", message: "Appventure set to in development. Delete this appventure from your maker profile.", preferredStyle: UIAlertControllerStyle.alert)
//                        ownedAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default , handler: nil))
//                        self.present(ownedAlert, animated: true, completion: nil)
//                    }
//                })
            }
        }))

        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func popController(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: IBActions
   
    
    @IBAction func detialsSegmentUpdate(_ sender: UISegmentedControl) {
        switch detailsSegmentControl.selectedSegmentIndex {
        case 0:
            view.bringSubview(toFront: detailsView)
        case 1:
            view.bringSubview(toFront: tableView)
            tableView.reloadData()
        case 2:
            view.bringSubview(toFront: tableView)
            tableView.reloadData()
        default: break
        }
    }
    
    @IBAction func downloadAdventure(_ sender: AnyObject) {
        if appventure.downloaded == true {
            performSegue(withIdentifier: Constants.StartAdventureSegue, sender: nil)
        } else {
            appventure.downloadAndSaveToCoreData(downloadComplete)
        }
    }
    
    func downloadComplete() {
        self.appventure.downloaded = true
        self.startButton.setTitle("Play", for: UIControlState())
    }
    
    //MARK: Image Function
    func halfImage(_ image: UIImage) -> UIImage? {
        if let halfImage = image.cgImage?.cropping(to: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height / 2.0)) as CGImage! {
            return UIImage(cgImage: halfImage)
        }
        return nil
    }
    
}

extension AppventureStartViewController : ParseQueryHandler {
    
     func handleQueryResults(_ objects: [AnyObject]?, handlerCase: String?) {
        switch handlerCase! {
        case AppventureReviews.appventureReviewsHC:
            reviews.removeAll()
            for object in objects! {
                let review = object.object(forKey: AppventureReviews.parseCol.review) as! String
                reviews.append(review)
            }
            tableView.reloadData()
        case CompletedAppventure.allCompletedHC:
            completedAppventures.removeAll()
            for object in objects! {
                let completdAppventure = CompletedAppventure(object: object)
                completedAppventures.append(completdAppventure)
            }
            completedAppventures.sort(by: { $0.time < $1.time })
            tableView.reloadData()
        default:
            break
        }
        
    }
    

    
    @IBAction func tapForDirections(_ sender: UITapGestureRecognizer) {
        openMapLocation(sender)
    }
    
    func openMapLocation(_ sender: AnyObject) {
        HelperFunctions.openMaps("Shoreditch, London", vc: self)
    }
    
}

extension AppventureStartViewController : UITableViewDataSource, UITableViewDelegate {
    

    func numberOfSections(in tableView: UITableView) -> Int {
        switch detailsSegmentControl.selectedSegmentIndex {
        case 1:
            if self.completedAppventures.count > 0 {
                self.tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
                self.tableView.backgroundView = UIView()
                return 1
            } else {
                let message = "No one has completed this appventure yet. Be the first!"
                HelperFunctions.noTableDataMessage(tableView, message: message)
            }
            return 0
        case 2:
            if self.reviews.count > 0 {
                self.tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if detailsSegmentControl.selectedSegmentIndex == 1 {
            return self.completedAppventures.count
        } else  {
            return self.reviews.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
 
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellID) as UITableViewCell!
        
        switch detailsSegmentControl.selectedSegmentIndex {
        case 1 :
            cell?.textLabel?.text = completedAppventures[indexPath.row].teamName
            let tString = HelperFunctions.formatTime(completedAppventures[indexPath.row].time, nano: false)
            cell?.detailTextLabel?.text = tString!
        case 2 :
            cell?.textLabel?.text = reviews[indexPath.row]
            cell?.detailTextLabel?.text = ""

        default : break
        }
        
        return cell!
    }
}


