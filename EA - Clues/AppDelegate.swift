
/**
 * Copyright (c) 2015-present, Parse, LLC.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

import UIKit
import Bolts
//import Parse
import FBSDKCoreKit
import FBSDKLoginKit
//import ParseFacebookUtilsV4
import GooglePlaces
import GoogleMaps
import CoreData


// If you want to use any of the UI components, uncomment this line
// import ParseUI

// If you want to use Crash Reporting - uncomment this line
// import ParseCrashReporting

struct Licensing {
    static let placesLicense = GMSPlacesClient.openSourceLicenseInfo()
    static let serviceLicense = GMSServices.openSourceLicenseInfo()
    
}



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    //--------------------------------------
    // MARK: - UIApplicationDelegate
    //--------------------------------------
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Enable storing and querying data from Local Datastore.
        // Parse.enableLocalDatastore()
        // ParseCrashReporting.enable()
        
        /* James Birtwell
        Parse.setApplicationId("OtvsGblO7FhGh2qD1LA1OPoxM1nz1HujjcSJbvg2", clientKey: "tclZbUGCOU20TEPUK6cfNMX4b3zElYwAZZpUxrWP")
        */
        
        //Appventure
//        Parse.setApplicationId("sO6wHlsJnZKM6s5L19C6uZfe6xxhDBSexxHW6yk8", clientKey: "nrfmHUjnJDt71YGNJA4PBbgxkEpenD1wzD8Xdy1n")
        
        //GMS
        
        GMSServices.provideAPIKey("AIzaSyDhyHZPC_SW2khLb02QqQ57fF5Wj68tjGs")
        GMSPlacesClient.provideAPIKey("AIzaSyDhyHZPC_SW2khLb02QqQ57fF5Wj68tjGs")
        
//        PFFacebookUtils.initializeFacebookWithApplicationLaunchOptions(launchOptions)
//        PFUser.enableAutomaticUser()
        
//        let defaultACL = PFACL();
        
        // If you would like all objects to be private by default, remove this line.
//        defaultACL.publicReadAccess = true
        
//        PFACL.setDefaultACL(defaultACL, withAccessForCurrentUser:true)
//        
//        if application.applicationState != UIApplicationState.Background {
//            
//            
//            let preBackgroundPush = !application.respondsToSelector("backgroundRefreshStatus:")
//            let oldPushHandlerOnly = !self.respondsToSelector("didReceiveRemoteNotification:fetchCompletionHandler:")
//
////            let oldPushHandlerOnly = !self.respondsToSelector(#selector(UIApplicationDelegate.application(_:didReceiveRemoteNotification:fetchCompletionHandler:)))
//            var noPushPayload = false;
//            if let options = launchOptions {
//                noPushPayload = options[UIApplicationLaunchOptionsRemoteNotificationKey] != nil;
//            }
//            if (preBackgroundPush || oldPushHandlerOnly || noPushPayload) {
//                PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
//            }
//        }
        
        
        //
        //  Swift 2.0
        //
        //        if #available(iOS 8.0, *) {
        //            let types: UIUserNotificationType = [.Alert, .Badge, .Sound]
        //            let settings = UIUserNotificationSettings(forTypes: types, categories: nil)
        //            application.registerUserNotificationSettings(settings)
        //            application.registerForRemoteNotifications()
        //        } else {
        //            let types: UIRemoteNotificationType = [.Alert, .Badge, .Sound]
        //            application.registerForRemoteNotificationTypes(types)
        //        }
        
        //Set status bar update
        
        return true
    }
    
    func application(_ application: UIApplication,
        open url: URL,
        sourceApplication: String?,
        annotation: Any) -> Bool {
            return FBSDKApplicationDelegate.sharedInstance().application(application,
                open: url,
                sourceApplication: sourceApplication,
                annotation: annotation)
    }
    
    
    //Make sure it isn't already declared in the app delegate (possible redefinition of func error)
    func applicationDidBecomeActive(_ application: UIApplication) {
        FBSDKAppEvents.activateApp()
    }
    
    
    //--------------------------------------
    // MARK: Push Notifications
    //--------------------------------------
    
//    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
//        let installation = PFInstallation.currentInstallation()
//        installation!.setDeviceTokenFromData(deviceToken)
//        installation!.saveInBackground()
//        
//        PFPush.subscribeToChannelInBackground("") { (succeeded: Bool, error: NSError?) in
//            if succeeded {
//                print("ParseStarterProject successfully subscribed to push notifications on the broadcast channel.\n");
//            } else {
//                print("ParseStarterProject failed to subscribe to push notifications on the broadcast channel with error = %@.\n", error)
//            }
//        }
//    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        if error._code == 3010 {
            print("Push notifications are not supported in the iOS Simulator.\n")
        } else {
            print("application:didFailToRegisterForRemoteNotificationsWithError: %@\n", error)
        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
//        PFPush.handlePush(userInfo)
//        if application.applicationState == UIApplicationState.Inactive {
//            PFAnalytics.trackAppOpenedWithRemoteNotificationPayload(userInfo)
//        }
    }
    
    ///////////////////////////////////////////////////////////
    // Uncomment this method if you want to use Push Notifications with Background App Refresh
    ///////////////////////////////////////////////////////////
    // func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
    //     if application.applicationState == UIApplicationState.Inactive {
    //         PFAnalytics.trackAppOpenedWithRemoteNotificationPayload(userInfo)
    //     }
    // }
    
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: URL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "JB.SocialWall" in the application's documents Application Support directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: "Model", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
    
    
}


