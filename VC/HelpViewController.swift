//
//  HelpViewController.swift
//  TaskTracker
//
//  Created by Margo on 2019-03-15.
//  Copyright © 2019 Gbc. All rights reserved.
//

import UIKit

class HelpViewController: UIViewController {

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

    @IBAction func closeHelp(_ sender: Any) {
        dismiss(animated: true)
        view.resignFirstResponder()
    }
}
