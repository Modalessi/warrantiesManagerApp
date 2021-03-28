//
//  ContactDeveloperViewController.swift
//  Thmanat
//
//  Created by Mohammed Alessi on 05/02/1442 AH.
//  Copyright © 1442 Mohammed Alessi. All rights reserved.
//

import UIKit

class ContactDeveloperViewController: UIViewController {
    
    
    // -------------------------------
    // MARK: -Outlets
    
    @IBOutlet weak var twitterAccountTextView: UITextView!
    @IBOutlet weak var emailTextView: UITextView!
    
    
    // -------------------------------
    // MARK: -Actions
    
    @IBAction func shareAppButtonTouched(_ sender: UIButton) {
        viewShareSheet()
    }
    
    // -------------------------------
    // MARK: -Activity Controller
    
    func viewShareSheet() {
        let shareItems = ["تطبيق ضمانات لحفظ ضمانات اجهزتك و سرعة الوصول اليها"]
        let activityControlelr: UIActivityViewController = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
        self.present(activityControlelr, animated: true, completion: nil)
    }
    
    
    // -------------------------------
    // MARK: -Setup Text Views
    
    func disableTextViews() {
        twitterAccountTextView.isEditable = false
        emailTextView.isEditable = false
    }
    
    // -------------------------------
    // MARK: -View Cycels
    
    override func viewDidLoad() {
        super.viewDidLoad()
        disableTextViews()
    }
    
}
