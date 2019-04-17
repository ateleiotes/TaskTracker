//
//  LoginViewController.swift
//  TaskTracker
//
//  Created by Margo on 2019-03-15.
//  Copyright © 2019 Gbc. All rights reserved.
//

import UIKit
import CoreData
class LoginViewController: UIViewController {

    @IBOutlet weak var username_txt: UITextField!
    @IBOutlet weak var password_txt: UITextField!
    @IBOutlet weak var error_lbl: UILabel!
    
    // Manage objects and update tasks
    var resultsController: NSFetchedResultsController<Users>!
    var managedContext: NSManagedObjectContext!
    var tasksArray = [NSManagedObject]()
    
    
    let coreData = CoreDataStack()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUsers()
    }
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let _ = sender as? UIBarButtonItem, let reg = segue.destination as? RegistrationViewController {
            reg.managedContext = coreData.managedContext
        }
    }
    
    func loadUsers() {
        let request: NSFetchRequest<Users> = Users.fetchRequest()
        // Sort by date
        let sortDescriptor = NSSortDescriptor(key: "username", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        resultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: coreData.managedContext, sectionNameKeyPath: nil, cacheName: nil)
        
        // Fetch data
        do {
            try resultsController.performFetch()
            print("Fetch successful")
        } catch  {
            print("Error performing fetch: \(error)")
        }
    }
    
    
    @IBAction func loginSuccess(_ sender: Any) {
        let res = resultsController.fetchedObjects!
        guard let name = username_txt.text, !name.isEmpty, let pass =  password_txt.text, !pass.isEmpty else {
            error_lbl.text = "Fields cannot be empty!"
            return
        }
        for r in res {
            if r.username == name && r.password == pass {
                performSegue(withIdentifier: "login", sender: self)
            } else {
                error_lbl.text = "Invalid username or password!"
            }
        }
        
    }
    
    @IBAction func openReg(_ sender: Any) {
        performSegue(withIdentifier: "openRegistration", sender: self)
    }
}
