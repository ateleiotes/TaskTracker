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
    
    
    var instanceMain:MainViewController!
    var taskName:String!
    var i = 0
    
    @IBOutlet weak var txt_name: UITextField!
    @IBOutlet weak var txt_date: UITextField!
    @IBOutlet weak var segmentedBtn: UISegmentedControl!
    var resultsController: NSFetchedResultsController<Tasks>!
    
    // MARK: - Properties

    // Manage objects and update tasks
    var managedContext: NSManagedObjectContext!
    var tasksArray = [NSManagedObject]()
    var fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Tasks")
    
    
    let coreData = CoreDataStack()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.becomeFirstResponder()
        loadTable()
        settextfields()
        
        
        
        
    }
    
    func settextfields() {
        let res = resultsController.fetchedObjects!
        for r in res {
            i+=1
            if r.name == taskName {
                txt_name.text = "\(r.name ?? "Task name" )"
                txt_date.text = "\(r.date ?? "Task date")"
                segmentedBtn.selectedSegmentIndex = Int(r.priority)
            }
        }
    }
    
    func loadTable() {
        let request: NSFetchRequest<Tasks> = Tasks.fetchRequest()
        // Sort by date
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
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
    @IBAction func saveEdit(_ sender: Any) {
        guard let name = txt_name.text, !name.isEmpty else {
            return
        }
        
        guard let date = txt_date.text, !date.isEmpty else {
            return
        }
        
        
        do {
            let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Tasks")
            fetchRequest.predicate = NSPredicate(format: "name = %@", taskName)
            let test = try managedContext.fetch(fetchRequest)
            let obj = test[0] as! NSManagedObject
            
            obj.setValue(name, forKey: "name")
            obj.setValue(date, forKey: "date")
            obj.setValue(Int16(segmentedBtn.selectedSegmentIndex), forKey: "priority")
            
            
            do {
                try managedContext.save()
                dismiss(animated: true)
                print("Edit Successful!")
            } catch  {
                print("Error saving task: \(error)")
            }
        } catch {
            print(error)
        }
    }
    
}


