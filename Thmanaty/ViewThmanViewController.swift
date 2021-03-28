//
//  ViewThmanViewController.swift
//  Thmanat
//
//  Created by Mohammed Alessi on 25/01/1442 AH.
//  Copyright © 1442 Mohammed Alessi. All rights reserved.
//

import UIKit

class ViewThmanViewController: UIViewController {

    var dataController: DataController?
    let dateController: DateController = DateController()
    let alertController: AlertController = AlertController()
    
    var warrantyPeriodYears: Int = 0
    var warrantyPeriodMonths: Int = 0
    
    var selectedWarranty: Warranty!
    
    
    
    // ------------------------------------------------
    // MARK: -Outlets
    
    @IBOutlet weak var warrantyImageView: UIImageView!
    @IBOutlet weak var devicNameTextField: UITextField!
    @IBOutlet weak var warrantyNumberTextField: UITextField!
    @IBOutlet weak var dateOfBuyTextField: UITextField!
    @IBOutlet weak var warrantyPeriodTextField: UITextField!
    @IBOutlet weak var endWarrantyTextField: UITextField!
    @IBOutlet weak var remainingPeriodTextField: UITextField!
    @IBOutlet weak var companyNameTextField: UITextField!
    @IBOutlet weak var supportNumberTextField: UITextField!
    
    
    
    // ------------------------------------------------
    // MARK: -Actions
    
    @IBAction func editButtonTouched(_ sender: UIBarButtonItem) {
        goToAddWarrantyView()
    }
    
    
    // ------------------------------------------------
    // MARK: -Prepare The UI With the data

    
    func getMonthsAndYears(period: Int) {
        var months = period % 365
        let years = (period - months) / 365
        months = months / 30
        
        self.warrantyPeriodMonths = months
        self.warrantyPeriodYears = years
    }
    
    func periodToText()-> String {
        
        var readableYearsText: String = ""
        var readableMonthsText: String = ""
        
        let years = warrantyPeriodYears
        let months = warrantyPeriodMonths
        
        
        if years > 0 {
            if years == 1 {readableYearsText = "سنه" }
            if years == 2 {readableYearsText = "سنتين" }
            if years > 2 && years < 11 {readableYearsText = "\(years) سنوات " }
            if years > 10 {readableYearsText = "\(years) سنه " }
        }
        
        if months > 0 {
            if months == 1 {readableMonthsText = "شهر" }
            if months == 2 {readableMonthsText = "شهرين" }
            if months > 2 && months < 11 {readableMonthsText = "\(months) شهور " }
            if months > 10 {readableMonthsText = "\(months) شهر" }
        }
        
        if readableYearsText == "" {
            return readableMonthsText
        } else if readableMonthsText == "" {
            return readableYearsText
        } else {
            return "\(readableYearsText) و \(readableMonthsText)"
        }

    }
    
    func dataToImage(data: Data)-> UIImage {
        return UIImage(data: data)!
    }
    
    func remaingPeriodToReadableText(remainingPeriod: Int16)-> String {
        if remainingPeriod == 0 {
            return "لقد انتهى الضمان"
        }else if remainingPeriod == 1 {
            return " تبقى يوم واحد"
        }else if remainingPeriod == 2 {
            return "تبقى يومين "
        } else if remainingPeriod > 2 && remainingPeriod < 11 {
            return "تبقى  \(remainingPeriod) ايام"
        } else {
            return "تبقى  \(remainingPeriod) يوم "
        }
    }
    
    func fillTextFields() {
        getMonthsAndYears(period: Int(selectedWarranty.warrantyPeriod))
        
        warrantyImageView.image = dataToImage(data: selectedWarranty.warrantyImage!)
        devicNameTextField.text =  " اسم الجهاز:  " + selectedWarranty.devicName! 
        warrantyNumberTextField.text =  "رقم الضمان:  " + selectedWarranty.warrantyNumber!
        dateOfBuyTextField.text = "تاريخ الشراء:  " + dateController.stringFromDate(date: selectedWarranty.buyDate!)
        warrantyPeriodTextField.text = "مدة الضمان:  " + "\(periodToText())"
        endWarrantyTextField.text = "تاريخ انتهاء الضمان:  " + dateController.stringFromDate(date: selectedWarranty.endDate!)
        remainingPeriodTextField.text = "المتبقي على انتهاء الضمان:  " + remaingPeriodToReadableText(remainingPeriod: selectedWarranty.remainingPeriod)
        companyNameTextField.text = "اسم الشركة:  " + selectedWarranty.companyName!
        supportNumberTextField.text =   "رقم الدعم الفني:  " + selectedWarranty.supportNumber!
    }
    
    
    
    
    // ------------------------------------------------
    // MARK: -View Cycles
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        fillTextFields()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fillTextFields()
        // Do any additional setup after loading the view.
    }
    

    // ------------------------------------------------
    // MARK: - Navigation
     
    func goToAddWarrantyView() {
        let addWarrantyVC = self.storyboard?.instantiateViewController(withIdentifier: "addThman") as! AddThmanViewController
        addWarrantyVC.selectedWarranty = self.selectedWarranty
        addWarrantyVC.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(addWarrantyVC, animated: true)
    }
    

}
