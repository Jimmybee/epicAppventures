////
////  AppventureHelpTableViewController.swift
////  EA - Clues
////
////  Created by James Birtwell on 08/08/2016.
////  Copyright © 2016 James Birtwell. All rights reserved.
////
//
//import UIKit
//
//protocol  AppventureHelpTableViewControllerDelegate: NSObjectProtocol {
//    func exitingAppventure()
//    func flagContent()
//}
//
//class AppventureHelpTableViewController: UITableViewController {
//    
//    
//    weak var delegate: AppventureHelpTableViewControllerDelegate?
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//    @IBOutlet weak var exitAppventureCell: UITableViewCell!
//    @IBOutlet weak var flagContentCell: UITableViewCell!
//
//    
//    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
//            
//            switch cell {
//            case exitAppventureCell:
//                exitAppventure()
//            case flagContentCell:
////                flagContent()
//            default: break
//            }
//        }
//        tableView.deselectRowAtIndexPath(indexPath, animated: true)
//    }
//    
//    func exitAppventure() {
//        let alert = UIAlertController(title: "Exit Appventure?", message: "Progress will be lost", preferredStyle: UIAlertControllerStyle.ActionSheet)
//        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
//        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Destructive, handler: { action in
//            self.dismissViewControllerAnimated(false, completion: nil)
//            self.delegate?.exitingAppventure()
//        }))
//        
//        self.presentViewController(alert, animated: true, completion: nil)
//    }
//    
//
//
//    @IBAction func backBttn(sender: AnyObject) {
//        self.dismissViewControllerAnimated(true, completion: nil)
//    }
//
//}
