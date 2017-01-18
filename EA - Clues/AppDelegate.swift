
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
    
    //MARK: Backendless
    
    let APP_ID = "975C9B70-4090-2D14-FFB1-BA95CB96F300"
    let SECRET_KEY = "EEE8A10A-F7FC-955E-FF84-EE35BF400800"
    let VERSION_NUM = "v1"
    
    var backendless = Backendless.sharedInstance()
    static var coreDataStack = CoreDataStack()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        backendless?.initApp(APP_ID, secret:SECRET_KEY, version:VERSION_NUM)
        backendless?.userService.setStayLoggedIn(true)

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
        
        print("AppDelegate -> application:openURL: \(url.scheme)")
        
        let backendless = Backendless.sharedInstance()
        let user = backendless?.userService.handleOpen(url)
        if user != nil {
            print("AppDelegate -> application:openURL: user = \(user)")
            centralDispatchGroup.leave()
            // do something, call some ViewController method, for example
        }
        
        return true
    }
    
//    func application(_ application: UIApplication,
//        open url: URL,
//        sourceApplication: String?,
//        annotation: Any) -> Bool {
//            return FBSDKApplicationDelegate.sharedInstance().application(application,
//                open: url,
//                sourceApplication: sourceApplication,
//                annotation: annotation)
//    }
    
    
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
    

}




