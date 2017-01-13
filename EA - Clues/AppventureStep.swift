//
//  AppventureStep.swift
//  MapPlay
//
//  Created by James Birtwell on 08/12/2015.
//  Copyright © 2015 James Birtwell. All rights reserved.
//

import Foundation
import MapKit
//import Parse
import CoreData


 class AppventureStep: NSManagedObject {
    
     static let appventureStepsHc = "appventureStepsHc"
    
     struct setup {
        static let textClue = "textClue"
        static let pictureClue = "pictureClue"
        static let soundClue = "soundClue"
        static let checkIn = "checkIn"
        static let isLocation = "isLocation"
        static let locationShown = "locationShown"
        static let compassShown = "compassShown"
        static let distanceShown = "distanceShown"
    }
    
        
    struct CoreKeys {
        static let entityName = "AppventureStep"
    }
    
    
    convenience init () {
        let context = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        let entity = NSEntityDescription.entity(forEntityName: CoreKeys.entityName, in: context)
        self.init(entity: entity!, insertInto: nil)
    }
    
    func updateCoreDataBridges() {
        if let image = self.image {self.imageData = UIImagePNGRepresentation(image)}
        self.setupObj = self.setup as NSObject
        self.answerHintObj = self.answerHint as NSObject
        self.answerTextObj = self.answerText as NSObject
        self.coordinateLon = self.coordinate.longitude
        self.coordinateLat = self.coordinate.latitude
    }
    
    func addToContext() {
        self.updateCoreDataBridges()
        let context = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        context.insert(self)
    }
    
    func setValuesForObject() {
        self.setup = self.setupObj! as! [String : Bool]
        self.answerHint = self.answerHintObj! as! [String]
        self.answerText = self.answerTextObj! as! [String]
        self.coordinate = CLLocationCoordinate2DMake(self.coordinateLat, self.coordinateLon)
        if let data = self.imageData {self.image = UIImage(data: data as Data)}
    }

//     var PFObjectID: String? = ""//Given at point of save/load
//     var AppventurePFObjectID: String?  = "" //Given at point of save/load
    
     //Required for valid save
//     var stepNumber: Int? // Given on creation
//     var nameOrLocation = "set location"
     var locationSubtitle = "set location"
//     var initialText = ""
     var image: UIImage?
     var imagePFFile: AnyObject?
//     var sound: NSData?
     var soundPFFile: AnyObject?
    
     var coordinate = kCLLocationCoordinate2DInvalid
     //var placemark: MKPlacemark?
    
     var answerText = [String]()
     var answerHint = [String]()
//     var freeHints: Int = 0
//     var hintPenalty: Int = 0
     var answerFormatHint = ""
//     var completionText = ""
 
//     var locationHidden = true
//     var checkInProximity = 0
    
     var saved = false
    
     var setup: [String:Bool] = [
        AppventureStep.setup.textClue : Bool(),
        AppventureStep.setup.pictureClue : Bool(),
        AppventureStep.setup.soundClue : Bool(),
        AppventureStep.setup.checkIn : Bool(),
        AppventureStep.setup.isLocation : Bool(),
        AppventureStep.setup.locationShown : Bool(),
        AppventureStep.setup.compassShown : Bool(),
        AppventureStep.setup.distanceShown : Bool(),
    ]
    
    static var dataLoads = [String : Int]()

    
     class func convertStringToDictionary(_ text: String) -> [String:Bool]? {
        if let data = text.data(using: String.Encoding.utf8) {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions()) as? [String:AnyObject]
                if let dict = json as! [String: Bool]! {
                    return dict
                }
            } catch {
                print("failedToLoadDict")
            }
            
        }
        
        return nil
        
    }
    
     func convertDictToJson(_ dict: [String: Bool]) -> String? {
        do {
            let theJSONData = try JSONSerialization.data(withJSONObject: dict , options: JSONSerialization.WritingOptions(rawValue: 0))
            let theJSONText = NSString(data: theJSONData, encoding: String.Encoding.ascii.rawValue) as! String
            return String(theJSONText)
            
        } catch {
            print("failedToCreateString")
            return nil
        }
    }


}

//copy init
extension AppventureStep {
    
    convenience init(step: AppventureStep) {
        let context = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        let entity = NSEntityDescription.entity(forEntityName: CoreKeys.entityName, in: context)
        self.init(entity: entity!, insertInto: nil)
        
        self.pFObjectID = step.pFObjectID
        self.appventurePFObjectID = step.appventurePFObjectID
        self.nameOrLocation = step.nameOrLocation
        self.locationSubtitle = step.locationSubtitle
        self.initialText = step.initialText
        self.answerText = step.answerText
        self.answerHint = step.answerHint
        self.answerFormatHint = step.answerFormatHint
        self.completionText = step.completionText
        self.stepNumber = step.stepNumber
        self.freeHints = step.freeHints
        self.hintPenalty = step.hintPenalty
        self.saved =  step.saved
        self.image = step.image
        self.imagePFFile = step.imagePFFile
        self.soundPFFile = step.soundPFFile
        self.sound = step.sound
        self.setup = step.setup
        self.coordinate = step.coordinate
        self.checkInProximity = step.checkInProximity
    }
    
}
