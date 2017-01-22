//
//  Appventure+CoreDataClass.swift
//  EA - Clues
//
//  Created by James Birtwell on 14/01/2017.
//  Copyright © 2017 James Birtwell. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation
import Alamofire

public class Appventure: NSManagedObject {
   
    var pfFile: AnyObject?
    
    static var currentAppventure: Appventure?
    var downloaded = true
    var liveStatus:LiveStatus {
            get { return LiveStatus(rawValue: self.liveStatusNum) ?? .inDevelopment }
            set { self.liveStatusNum = newValue.rawValue }
    }
    var appventureSteps: [AppventureStep] {
        get { return Array(steps) }
        set { print("setting steps") }
    }
    
    struct CoreKeys {
        static let entityName = "Appventure"
    }
    
    var appventureRating = AppventureRating()
    var saveImage = false
    
//    var distanceToSearch = 0.0
//    var tags: [String]?
    var rating = 5
    
    
    /// init for a new appventure
    convenience init () {
        let context = AppDelegate.coreDataStack.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: CoreKeys.entityName, in: context)
        self.init(entity: entity!, insertInto: context)
        
        let coordinate: CLLocationCoordinate2D = kCLLocationCoordinate2DInvalid
        self.location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        self.liveStatus = .inDevelopment
        self.owner = CoreUser.user!
    }
    
    /// init for appventure using backendless API data
    convenience init (backendlessAppventure: BackendlessAppventure, persistent: Bool) {
        let context = persistent ? AppDelegate.coreDataStack.persistentContainer.viewContext : AppDelegate.coreDataStack.tempContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: CoreKeys.entityName, in: context)
        self.init(entity: entity!, insertInto: context)
        
        self.backendlessId = backendlessAppventure.objectId
        self.title = backendlessAppventure.title
        self.liveStatusNum = backendlessAppventure.liveStatusNum
        self.startingLocationName = backendlessAppventure.startingLocationName
        self.subtitle = backendlessAppventure.subtitle
        let geoPoint = backendlessAppventure.location
        self.location = CLLocation(latitude: geoPoint!.latitude as Double, longitude: geoPoint!.longitude as Double)
        self.liveStatusNum = backendlessAppventure.liveStatusNum
        
        for backendlessStep in backendlessAppventure.steps {
            let step = AppventureStep(backendlessStep: backendlessStep, persistent: persistent)
            self.addToSteps(step)
        }
    }
    
    //Save methods
    
    func downloadAndSaveToCoreData (_ handler: () -> ()) {
     //   AppventureStep.loadSteps(self, handler: handler)
    }
    
    //Delete from context
    
    func deleteAppventure() {
//        self.deleteAppventureFromBackend()
        AppDelegate.coreDataStack.delete(object: self, completion: nil)
    }
    
    
    //MARK: Load Image
    func loadImageFor(cell: AppventureImageCell) {
        guard let objectId = self.backendlessId else { return }
        let url = "https://api.backendless.com/\(AppDelegate.APP_ID)/\(AppDelegate.VERSION_NUM)/files/myfiles/\(objectId)/image.jpg"
        Alamofire.request(url).response { response in
            guard let data = response.data else {return}
            guard let image = UIImage(data: data) else { return }
            self.image = image
            cell.appventureImage.image = image
            cell.setNeedsDisplay()
        }
    }
}

enum LiveStatus: Int16 {
    case live = 0
    case waitingForApproval = 1
    case inDevelopment = 2
    case local = 3
    
    var label: String {
        switch self {
        case .live: return "Live"
        case .waitingForApproval: return "Awaiting Approval"
        case .inDevelopment: return "In Develoopment"
        case .local: return "Local"
        }
    }
    
    func segmentValue() -> Int {
        switch self {
        case .inDevelopment: return 0
        case .local: return 1
        case .waitingForApproval: return 2
        case .live: return 3
        }
    }
}

