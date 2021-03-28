//
//  ViewController.swift
//  Thmanat
//
//  Created by Mohammed Alessi on 24/01/1442 AH.
//  Copyright © 1442 Mohammed Alessi. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    var dataController: DataController?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    
    
    
    //---------------------------------------------------
    // MARK: -Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAdd" {
            let addThmanViewController = segue.destination as! AddThmanViewController
            addThmanViewController.dataController = dataController
        } else if segue.identifier == "toView" {
            let ThmanatViewController = segue.destination as! WarrantyTableViewController
            ThmanatViewController.dataController = dataController
        } else {
            
        }
    }


}


