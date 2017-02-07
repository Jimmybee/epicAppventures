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
import SwiftyJSON

class LocalTableViewController: BaseTableViewController, CLLocationManagerDelegate{
    
    let firstLaunchKey = "firstLaunch"
    let howToVC = "HowToVC"
    let liveAppventures = "liveAppventures"
    let LocalAppventures = "LocalAppventures"
    
    struct StoryboardNames {
        static let TextCellID = "TextCell"
        static let startupLogin = "startupLogin"
    }
    
    let locationManager = CLLocationManager()
    var publicAppventures = [Appventure]()
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

        //Notifications
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(LocalTableViewController.beginRefresh), name: NSNotification.Name(rawValue: User.userInitCompleteNotification), object: nil)
        notificationCenter.addObserver(self, selector: #selector(LocalTableViewController.beginRefresh), name: NSNotification.Name(rawValue: User.userLoggedOutNotification), object: nil)

        notificationCenter.addObserver(self, selector: #selector(LocalTableViewController.beginRefresh), name: NSNotification.Name(rawValue: skipLoginNotification), object: nil)
        
        notificationCenter.addObserver(self, selector: #selector(getBackendlessAppventure), name: NSNotification.Name(rawValue: Notifications.reloadCatalogue), object: nil)
        //MARK: TableViewLoad
        
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.dataSource = self
        tableView.delegate = self
        

        if let mtvc = self.tabBarController as? MainTabBarController {
            mtvc.stdFrame  = self.tabBarController?.tabBar.frame

        }
        
        UserManager.setupUser(completion: setupComplete)

        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        HelperFunctions.unhideTabBar(self)
    }
    
    func setupComplete() {
        if CoreUser.user?.userType == .noLogin {
            self.performSegue(withIdentifier: StoryboardNames.startupLogin, sender: nil)
        } else {
            NotificationCenter.default.post(name: Notification.Name(rawValue: Notifications.reloadCatalogue), object: self)
        }
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lastLocation = locations.first?.coordinate
        print(lastLocation ?? "no location")
        if refreshing == false {
            refreshing = true
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        publicAppventuresMessage = "Update location settings to get adventures in your area."
        let london = CLLocationCoordinate2D(latitude: 51.5072, longitude: 0.1275)
        if lastLocation == nil {lastLocation = london}

    }
    
    func beginRefresh() {
        refreshSpinner.beginRefreshing()
        tableView.isUserInteractionEnabled = false
        self.refeshTable(refreshSpinner)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Actions
    
    @IBAction func refeshTable(_ sender: UIRefreshControl) {
        publicAppventures.removeAll()
        tableView.reloadData()
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
                        aastvc.appventure = CoreUser.user!.downloadedArray[indexPath.row]
                    case 1:
                        aastvc.appventure = publicAppventures[indexPath.row]
                    default:
                        break
                    }
                }
            }
        }
    }
    
    func checkFirstLaunch() {
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
            if CoreUser.user!.downloadedArray.count > 0 {
                self.tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
                self.tableView.backgroundView = UIView()
                return 1
            } else {
                HelperFunctions.noTableDataMessage(tableView, message: publicAppventuresMessage)
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
        default:
            break
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rows = 0
        switch localPublicControl.selectedSegmentIndex {
        case 0:
           rows = CoreUser.user!.downloadedArray.count
        case 1:
            rows = publicAppventures.count
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
            cell.appventure = CoreUser.user!.downloadedArray[row]
        case 1:
            cell.appventure = publicAppventures[row]
        default:
            break
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "Alt1", sender: indexPath)
    }
    
}

// MARK: API Calls

extension LocalTableViewController {
    
    /// Move to backendless/model layer.
    func getBackendlessAppventure() {
        showProgressView()
        let queryOptions = QueryOptions()
        queryOptions.relationsDepth = 1;
        
        let liveWhere = "liveStatusNum = \(2)"
        let dataQuery = BackendlessDataQuery()
        dataQuery.queryOptions = queryOptions;
        let distanceWhere = "distance( 30.26715, -97.74306, location.latitude, location.longitude ) < mi(2000000)"
        dataQuery.whereClause = distanceWhere + " AND " + liveWhere
        
        BackendlessAppventure.loadBackendlessAppventures(persistent: false, dataQuery: dataQuery) { (response, fault) in
            self.hideProgressView()
            if fault == nil {
                guard let appventures = response as? [Appventure] else { return }
                self.publicAppventures = appventures
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                self.setDownloadForAppventures()
            } else {
                //display message
            }
        }
    }
    
    private func setDownloadForAppventures() {
        for (index, appventure) in publicAppventures.enumerated() {
            let appventureId = appventure.backendlessId
            if CoreUser.user!.downloadedArray.contains(where: { (appventure) -> Bool in
                appventure.backendlessId == appventureId
            }) {
                appventure.downloaded = true
                publicAppventures.remove(at: index)
            } else {
                appventure.downloaded = false
            }
        }
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
