//
//  AddHintTableViewController.swift
//  EA - Clues
//
//  Created by James Birtwell on 15/08/2016.
//  Copyright © 2016 James Birtwell. All rights reserved.
//

import UIKit

class AddHintTableViewController: UITableViewController {
    
    var step = AppventureStep()

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if self.step.answerHint.count > 0 {
            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
            self.tableView.backgroundView = UIView()
            return 1
        } else {
            let message = "No hints added yet."
            HelperFunctions.noTableDataMessage(tableView, message: message)
        }
        return 0
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return step.answerHint.count
    }
    
    @IBAction func addHint(sender: AnyObject) {
        let alert = UIAlertController(title: "New Hint", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Confirm", style: UIAlertActionStyle.Default, handler: { action in
            let newHint = alert.textFields![0].text
            self.addAnswerToTable(newHint)
        }))
        
        alert.addTextFieldWithConfigurationHandler { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter Answer"
        }
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func addAnswerToTable(textfieldString: String?) {
        if let hint = textfieldString {
            self.step.answerHint.append(hint)
            tableView.reloadData()
        }
    }
    
    func updateAnswerInTable(textFieldString: String?, index: Int) {
        if let hint = textFieldString {
            self.step.answerHint[index] = hint
            tableView.reloadData()
        }
    }
    
    @IBAction func backButton(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let alert = UIAlertController(title: "Edit Hint", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Confirm", style: UIAlertActionStyle.Default, handler: { action in
            let newAnswer = alert.textFields![0].text
            self.updateAnswerInTable(newAnswer, index: indexPath.row)
        }))
        
        alert.addTextFieldWithConfigurationHandler { (textField : UITextField!) -> Void in
            textField.text = self.step.answerHint[indexPath.row]
        }
        
        self.presentViewController(alert, animated: true, completion: nil)
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        cell.textLabel?.text = step.answerHint[indexPath.row]
        
        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            self.step.answerHint.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            
        }
    }
}
