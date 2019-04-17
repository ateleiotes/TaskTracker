//
//  RegistrationViewController.swift
//  TaskTracker
//
//  Created by Margo on 2019-03-15.
//  Copyright © 2019 Gbc. All rights reserved.
//

import UIKit
import CoreData

class RegistrationViewController: UIViewController {
    @IBOutlet weak var error_lbl: UILabel!
    @IBOutlet weak var name_txt: UITextField!
    @IBOutlet weak var pass_txt: UITextField!
    @IBOutlet weak var comfirm_txt: UITextField!
    @IBOutlet weak var email_txt: UITextField!
    
    
    
    // Core data properties
    var managedContext: NSManagedObjectContext!
    var resultsController: NSFetchedResultsController<Users>!
    
    let coreData = CoreDataStack()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.becomeFirstResponder()
        managedContext = coreData.managedContext
    }
    

    @IBAction func submitRegistration(_ sender: Any) {
        
        // Check for nil textFields
        guard let name = name_txt.text, !name.isEmpty, let pass =  pass_txt.text, !pass.isEmpty, let email =  email_txt.text, !email.isEmpty else {
            error_lbl.text = "Fields cannot be empty!"
            return
        }
        
        
        // Validate password
        if isValidPassword(testStr: pass) == true {
            
            // Compare password fields
            if comfirm_txt.text == pass {
                
                // Validate Email
                if isValidEmailAddress(emailAddressString: email) == true {
                    let user = Users(context: managedContext)
                    user.username = name
                    user.password = pass
                    user.email = email
                    
                    // Save new user
                    do {
                        try managedContext.save()
                        dismiss(animated: true)
                        print("Save successful")
                        view.resignFirstResponder()
                    } catch  {
                        print("Error saving task: \(error)")
                    }
                } else {
                    error_lbl.text = "Invalid Email!"
                }
                
            } else {
                error_lbl.text = "Passwords do not match"
            }
        } else {
            error_lbl.text = " Passwords must have at least one uppercase, one digit and must be 8 characters"
        }
    }
    @IBAction func backToLogin(_ sender: Any) {
        view.resignFirstResponder()
        dismiss(animated: true)
        
    }
    
    // Helper functions
    
    func isValidEmailAddress(emailAddressString: String) -> Bool {
        
        var returnValue = true
        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        
        do {
            let regex = try NSRegularExpression(pattern: emailRegEx)
            let nsString = emailAddressString as NSString
            let results = regex.matches(in: emailAddressString, range: NSRange(location: 0, length: nsString.length))
            
            if results.count == 0
            {
                returnValue = false
            }
            
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        
        return  returnValue
    }
    func isValidPassword(testStr:String?) -> Bool {
        
        // at least one uppercase,
        // at least one digit
        // at least one lowercase
        // 8 characters total
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8,}")
        return passwordTest.evaluate(with: testStr)
    }
}
