//
//  EditTaskViewController.swift
//  TaskTracker
//
//  Created by Margo on 2019-03-14.
//  Copyright © 2019 Gbc. All rights reserved.
//

import UIKit
import CoreData

class EditTaskViewController: UIViewController {
    
    @IBOutlet weak var txt_name: UITextField!
    @IBOutlet weak var txt_date: UITextField!
    @IBOutlet weak var segmentedBtn: UISegmentedControl!
    
    // MARK: - Properties
    var managedContext: NSManagedObjectContext!
    // Manage objects and update tasks
    var resultsController: NSFetchedResultsController<Tasks>!
    
    let coreData = CoreDataStack()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.becomeFirstResponder()
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func cancelEdit(_ sender: Any) {
        dismiss(animated: true)
        view.resignFirstResponder()
    }
    
    @IBAction func doneEdit(_ sender: Any) {
        
      

    }

}
