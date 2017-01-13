//
//  Alt1LocalTableViewController.swift
//  EA - Clues
//
//  Created by James Birtwell on 04/02/2016.
//  Copyright © 2016 James Birtwell. All rights reserved.
//

import UIKit
//import Parse
import CoreLocation
import FBSDKCoreKit


class LocalTableViewController: UITableViewController, CLLocationManagerDelegate{
    
    
    let firstLaunchKey = "firstLaunch"
    let howToVC = "HowToVC"
    let liveAppventures = "liveAppventures"
    let LocalAppventures = "LocalAppventures"
    
    struct StoryboardNames {
        static let TextCellID = "TextCell"
        static let startupLogin = "startupLogin"
    }
    
    let locationManager = CLLocationManager()
    var localAppventures = [Appventure] ()
    var publicAppventures = [Appventure] ()
    var friendsAppventures = [Appventure] ()
    var searchController = UISearchController()
    
    @IBOutlet weak var localPublicControl: UISegmentedControl!
    
    //Don't neeed
    var lastLocation: CLLocationCoordinate2D?
    var filter = Filter()
    var refreshing = false
    
    @IBOutlet weak var refreshSpinner: UIRefreshControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("\(CLLocationManager.authorizationStatus())")
        
        //MARK: LocationManager
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
//        self.locationManager.requestAlwaysAuthorization()
        

        //Notifications
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(LocalTableViewController.beginRefresh), name: NSNotification.Name(rawValue: User.userInitCompleteNotification), object: nil)

//        notificationCenter.addObserver(self, selector: #selector(loadAppventures), name: User.userInitCompleteNotification, object: nil)
//        notificationCenter.addObserver(self, selector: #selector(beginRefresh), name: User.userLoggedOutNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(LocalTableViewController.beginRefresh), name: NSNotification.Name(rawValue: User.userLoggedOutNotification), object: nil)

        notificationCenter.addObserver(self, selector: #selector(LocalTableViewController.beginRefresh), name: NSNotification.Name(rawValue: skipLoginNotification), object: nil)

//        notificationCenter.addObserver(self, selector: #selector(beginRefresh), name: skipLoginNotification, object: nil)

        
        if !User.checkLogin(true, vc: self) {
            self.performSegue(withIdentifier: StoryboardNames.startupLogin, sender: nil)
        }
        
        //MARK: TableViewLoad
        
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.dataSource = self
        tableView.delegate = self
        

        if let mtvc = self.tabBarController as? MainTabBarController {
            mtvc.stdFrame  = self.tabBarController?.tabBar.frame

        }
        
        Appventure.loadAppventuresFromCoreData(handlingDownloadedAppventures)

    }
    
    func handlingDownloadedAppventures(_ appventures: [Appventure]) -> () {
//     appventures.count
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
         HelperFunctions.unhideTabBar(self)
    }
    

    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lastLocation = locations.first?.coordinate
        print(lastLocation ?? "no location")
        if refreshing == false {
            loadAppventures()
            refreshing = true
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        publicAppventuresMessage = "Update location settings to get adventures in your area."
        let london = CLLocationCoordinate2D(latitude: 51.5072, longitude: 0.1275)
        if lastLocation == nil {lastLocation = london}

    }
    
    func beginRefresh() {
        self.refreshSpinner.beginRefreshing()
        self.tableView.isUserInteractionEnabled = false
        self.refeshTable(refreshSpinner)
    }
    
    
    func loadLiveAdventures() {
        if let location = lastLocation {
            Appventure.loadLiveAdventures(location, handler: self, handlerCase: liveAppventures)            
        }
    }
    
    func loadUserAdventures() {
        
        Appventure.loadAppventuresFromCoreData { (downloadedAppventures) in
            for appventure in downloadedAppventures {
                print(appventure.liveStatus)
                if appventure.liveStatus != LiveStatus.inDevelopment{
                    self.localAppventures.append(appventure)
                }

            }
            self.tableView.reloadData()
        }
        
        if let user = User.user {
//            Appventure.loadUserAppventure(user.pfObject, handler: self, handlerCase: LocalAppventures)
            FriendsAdventures.fetchFriendAdventures({ (friendsAdventures) in
                self.friendsAppventures = friendsAdventures
                self.tableView.reloadData()
            })
            
        }
    }
    
    func loadAppventures() {
        self.loadLiveAdventures()
        self.loadUserAdventures()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Actions
    
    @IBAction func refeshTable(_ sender: UIRefreshControl) {
        self.localAppventures.removeAll()
        self.publicAppventures.removeAll()
        self.friendsAppventures.removeAll()
        self.tableView.reloadData()
        locationManager.requestLocation()
    }
    
    @IBAction func localPublicChange(_ sender: UISegmentedControl) {
        tableView.reloadData()
    }
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //segue to appventure details
        if segue.identifier == "Alt1" {
            if let indexPath = sender as? IndexPath {
                if let aastvc = segue.destination as? AppventureStartViewController {
                    switch localPublicControl.selectedSegmentIndex {
                    case 0:
                        aastvc.appventure = localAppventures[indexPath.row]
                    case 1:
                        aastvc.appventure = publicAppventures[indexPath.row]
                    case 2:
                        aastvc.appventure = friendsAppventures[indexPath.row]
                    default:
                        break
                    }
                }
            }
        }
        if segue.identifier == StoryboardNames.startupLogin {
            if let lvc = segue.destination as? LoginViewController {
                lvc.delegate = self
            }
        }
    }
    
    func checkFirstLaunch() {
        print("checking")
        let defaults = UserDefaults.standard
        print(defaults.bool(forKey: firstLaunchKey))
        if defaults.bool(forKey: firstLaunchKey) == false {
            let storyBoard = UIStoryboard(name: "LaunchAppventure", bundle:nil)
            if let htvc = storyBoard.instantiateViewController(withIdentifier: howToVC) as? HowToViewController {
                self.present(htvc, animated: true, completion: nil)
            }
        }
        defaults.set(false, forKey: firstLaunchKey)
    }

    //MARK: Table functions
    var publicAppventuresMessage = "There are no adventures available on our servers at the moment."
    var friendsAppventuresMessage = "There are no adventures that your friends have shared with you."

    override func numberOfSections(in tableView: UITableView) -> Int {
        switch localPublicControl.selectedSegmentIndex {
        case 0:
            if self.localAppventures.count > 0 {
                self.tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
                self.tableView.backgroundView = UIView()
                return 1
            } else {
                if User.user == nil {
                    let message = "You need to sign in to create your own adventures."
                    HelperFunctions.noTableDataMessage(tableView, message: message)
                } else {
                    let message = "Go to the maker tab to create your own adventures."
                    HelperFunctions.noTableDataMessage(tableView, message: message)
                }
           
            }
            return 0
        case 1:
            if self.publicAppventures.count > 0 {
                self.tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
                self.tableView.backgroundView = UIView()
                return 1
            } else {
                HelperFunctions.noTableDataMessage(tableView, message: publicAppventuresMessage)
            }
            return 0
        case 2:
            if self.friendsAppventures.count > 0 {
                self.tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
                self.tableView.backgroundView = UIView()
                return 1
            } else {
                HelperFunctions.noTableDataMessage(tableView, message: friendsAppventuresMessage)
            }
            return 0
        default:
            break
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rows = 0
        switch localPublicControl.selectedSegmentIndex {
        case 0:
           rows = localAppventures.count
        case 1:
            rows = publicAppventures.count
        case 2:
            rows = friendsAppventures.count
        default:
            break
        }
        return rows
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StoryboardNames.TextCellID, for: indexPath) as! LocalAppventureTableViewCell
        let row = indexPath.row
        switch localPublicControl.selectedSegmentIndex {
        case 0:
            cell.appventure = localAppventures[row]
        case 1:
            cell.appventure = publicAppventures[row]
        case 2:
            cell.appventure = friendsAppventures[row]
        default:
            break
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "Alt1", sender: indexPath)
    }
    
}

extension LocalTableViewController : ParseQueryHandler {
    
    func getRatings() {
        
    }
    
    func handleQueryResults(_ objects: [AnyObject]?, handlerCase: String?) {
//        if let isPFArray = objects as [AnyObject]! {
//            for object in isPFArray {
//                let appventure = Appventure(object: object)
//                let appventureLocation = CLLocation(latitude: appventure.coordinate!.latitude, longitude: appventure.coordinate!.longitude)
////                if let gotLocation = lastLocation as CLLocation! {
////                    appventure.distanceToSearch = gotLocation.distanceFromLocation(appventureLocation)
////                }
//                
//                if let handle = handlerCase {
//                    switch handle {
//                    case liveAppventures:
//                        if appventure.liveStatus == .live {
//                            self.publicAppventures.append(appventure)
//                        }
//                    case LocalAppventures:
//                        if appventure.liveStatus == .local {
//                            if appventure.userID == User.user?.pfObject {
//                                self.localAppventures.append(appventure)
//                            }
//                        }
//                        if appventure.liveStatus == .waitingForApproval {
//                            if appventure.userID == User.user?.pfObject {
//                                self.localAppventures.append(appventure)
//                            }
//                        }
//                    default:
//                        break
//                    }
//                }
//                
//            }
        
//        }
        
        self.tableView.reloadData()
        self.tableView.isUserInteractionEnabled = true
        self.refreshSpinner.endRefreshing()
        self.refreshing = false
        
    }
}


extension LocalTableViewController : LoginViewControllerDelegate {
    func skippedLogin() {
         loadAppventures()
    }
}

