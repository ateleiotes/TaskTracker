//
//  AddTaskViewController.swift
//  TaskTracker
//
//  Created by Margo on 2019-03-14.
//  Copyright © 2019 Gbc. All rights reserved.
//

import UIKit
import CoreData


class AddTaskViewController: UIViewController {
    let instanceofMain = MainViewController()
    
    @IBOutlet weak var txt_name: UITextField!
    @IBOutlet weak var txt_date: UITextField!
    @IBOutlet weak var segmentedBtn: UISegmentedControl!
    
    // MARK: - Properties
    var managedContext: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.becomeFirstResponder()
    }
    

    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true)
        view.resignFirstResponder()
    }
    
    @IBAction func done(_ sender: Any) {
        // Check if text is empty
        //NOTE ADD ALERT
        guard let name = txt_name.text, !name.isEmpty else {
            return
        }
        
        guard let date = txt_date.text, !date.isEmpty else {
            return
        }
        
        let task = Tasks(context: managedContext)
        task.name = name
        task.priority = Int16(segmentedBtn.selectedSegmentIndex)
        task.date = date
        
        do {
            try managedContext.save()
            instanceofMain.tableView.reloadData()
            dismiss(animated: true)
            print("Save successful")
            view.resignFirstResponder()
        } catch  {
            print("Error saving task: \(error)")
        }
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

    


