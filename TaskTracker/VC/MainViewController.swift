//
//  MainViewController.swift
//  TaskTracker
//
//  Copyright © 2019 Gbc. All rights reserved.
//

import UIKit
import CoreData

class MainViewController: UITableViewController {
    var taskId:String!
    var indexPath: NSIndexPath!
    var name:String!

    // MARK: - Properties
    
    // Manage objects and update tasks
    var resultsController: NSFetchedResultsController<Tasks>!
    var managedContext: NSManagedObjectContext!
    var tasksArray = [NSManagedObject]()
    
    
    let coreData = CoreDataStack()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTable()
        
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
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        // Initialize managedContext
        if let _ = sender as? UIBarButtonItem, let vc = segue.destination as? AddTaskViewController {
            vc.managedContext = coreData.managedContext
        }
       
        if segue.identifier == "editTask" {
            let indexPath = tableView.indexPathForSelectedRow //optional, to get from any UIButton for example
            let currentCell = tableView.cellForRow(at: indexPath as! IndexPath) as UITableViewCell?
            
            
            
            let res = resultsController.fetchedObjects!
            for r in res {
                if r.name == currentCell?.textLabel!.text {
                     name = r.name
                }
               
            }
            if let ed = segue.destination as? EditTaskViewController,
                let taskId = name{
                ed.taskName = taskId
                ed.managedContext = coreData.managedContext
            }
        
        }
        
    }
    
    // MARK: - Table view data source
    
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return resultsController.sections?[section].objects?.count ?? 0
    }
    
    // Set up cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Task", for: indexPath)
        // Configure Cell
        let task = resultsController.object(at: indexPath)
        cell.textLabel?.text = task.name
        cell.textLabel?.textColor = UIColor.white
        return cell
        
        
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, success) in
            success(true)
        }
        action.image = UIImage(named:"trash.png")
        action.backgroundColor = .red
        
        return UISwipeActionsConfiguration(actions: [action])
    }

    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .destructive, title: "Check") { (action, view, completion) in
            completion(true)
        }
        action.image = UIImage(named:"check.png")
        action.backgroundColor = .green
        
        return UISwipeActionsConfiguration(actions: [action])
    }

    // Long press to open edit task view
    
    @IBAction func openDetailView(_ sender: Any) {
        performSegue(withIdentifier: "editTask", sender: indexPath.row)
    }
    
    // Delete
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            tableView.beginUpdates()
            managedContext.delete(self.tasksArray[indexPath.row])
            tableView.deleteRows(at: [indexPath], with: .fade)
            do {
                try managedContext.save()
                self.tasksArray.removeAll()
                loadTable()
                print("Save successful")
            } catch  {
                print("Error performing fetch: \(error)")
            }
            tableView.endUpdates()
    
    }
    @IBAction func openDetails(_ sender: Any) {
        performSegue(withIdentifier: "detailsSegue", sender: self)
    }
    
    @IBAction func showHelp(_ sender: Any) {
        performSegue(withIdentifier: "showHelp", sender: self)
    }
   
   @IBAction func logout(_ sender: Any) {
        dismiss(animated: true)
    }
    
}

