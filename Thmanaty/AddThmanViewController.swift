//
//  AddThmanViewController.swift
//  Thmanat
//
//  Created by Mohammed Alessi on 25/01/1442 AH.
//  Copyright © 1442 Mohammed Alessi. All rights reserved.
//

import UIKit
import CoreData

class AddThmanViewController: UIViewController {

    var dataController: DataController?
    let dateController: DateController = DateController()
    let alertController: AlertController = AlertController()
    
    
    
    let imagePicker: UIImagePickerController = UIImagePickerController()
    
    
    var dateOfBuy: Date = Date()
    var warrantyPeriodYears: Int = 0
    var warrantyPeriodMonths: Int = 0
    
    var selectedWarranty: Warranty?
    var isEditView: Bool = false
    
    // -----------------------------------------------------
    // MARK: - Outlets
    
    @IBOutlet weak var warrantyImageView: UIImageView!
    @IBOutlet weak var deviceNameTextField: UITextField!
    @IBOutlet weak var buyDateTextField: UITextField!
    @IBOutlet weak var warrantyPeriodTextField: UITextField!
    @IBOutlet weak var warrantyNumberTextField: UITextField!
    @IBOutlet weak var companyNameTextField: UITextField!
    @IBOutlet weak var supportNumberTextField: UITextField!
    
    
    // -----------------------------------------------------
    // MARK: -Add Delegates
    func addTextFieldDelegate() {
        deviceNameTextField.delegate = self
        buyDateTextField.delegate = self
        warrantyPeriodTextField.delegate = self
        warrantyNumberTextField.delegate = self
        companyNameTextField.delegate = self
        supportNumberTextField.delegate = self
    }
    
    func addImagePickerDelegate() {
        imagePicker.delegate = self
        
    }
    
    // -----------------------------------------------------
    // MARK: -Set as Edit View
    
    func getMonthsAndYears(period: Int) {
        var months = period % 365
        let years = (period - months) / 365
        months = months / 30
        
        self.warrantyPeriodMonths = months
        self.warrantyPeriodYears = years
    }
    
    func fillTextFields(selectedWarranty: Warranty) {
        getMonthsAndYears(period: Int(selectedWarranty.warrantyPeriod))
        warrantyImageView.image = UIImage(data: selectedWarranty.warrantyImage!)
        deviceNameTextField.text = selectedWarranty.devicName
        buyDateTextField.text = dateController.stringFromDate(date: selectedWarranty.buyDate!)
        warrantyPeriodTextField.text = periodToText()
        warrantyNumberTextField.text = selectedWarranty.warrantyNumber
        companyNameTextField.text = selectedWarranty.companyName
        supportNumberTextField.text = selectedWarranty.supportNumber
    }
    
    func setAsEditView() {
        isEditView = true
        dateOfBuy = selectedWarranty!.buyDate!
        getMonthsAndYears(period: Int(selectedWarranty!.warrantyPeriod))
        fillTextFields(selectedWarranty: selectedWarranty!)
    }
    
    func updateSelectedWarranty(completion: ()->Void) {
        
        // tack Data From UI
        let deviceName: String = deviceNameTextField.text!
        let dateOfBuy = self.dateOfBuy
        let warrantyPeriod: Int16 = Int16(calculatDays(years: warrantyPeriodYears, months: warrantyPeriodMonths))
        let warrantyNumber: String = warrantyNumberTextField.text!
        let compnayName: String = companyNameTextField.text!
        let supportNumber: String = supportNumberTextField.text!
        let endDate: Date = calculateEndDate()
        var remainingPeriod: Int16 = Int16(dateController.intervalBetweenDates(date1: Date(), date2: endDate))
        
        if remainingPeriod < 0 {
            remainingPeriod = 0
        }
        
        // write data to context
        selectedWarranty!.devicName = deviceName
        selectedWarranty!.buyDate = dateOfBuy
        selectedWarranty!.warrantyPeriod = warrantyPeriod
        selectedWarranty!.warrantyNumber = warrantyNumber
        selectedWarranty!.companyName = compnayName
        selectedWarranty!.supportNumber = supportNumber
        selectedWarranty!.endDate = endDate
        selectedWarranty!.remainingPeriod = remainingPeriod
        selectedWarranty!.warrantyImage = imageToData(image: warrantyImageView.image!)
        
        do {
            try selectedWarranty?.managedObjectContext?.save()
            completion()
        } catch {
            let errorAlert = alertController.setErrorAlert(error: .contextNotSaved)
            self.present(errorAlert, animated: true, completion: nil)
        }
    }
    
    
    // -----------------------------------------------------
    // MARK: - Actions
    @IBAction func cameraButtonTouched(_ sender: UIButton) {
        showActionSheet()
    }
    
    @IBAction func saveButtonTouched(_ sender: UIButton) {
        if TextFieldsIsFilled() {
            if isEditView {
                updateSelectedWarranty() {
                        let doneAlert = alertController.setDoneAlert(done: .dataSaved) { (doneButton) in
                            self.navigationController?.popViewController(animated: true)
                    }
                    self.present(doneAlert, animated: true, completion: nil)
                }
            } else {
                saveData {
                        let doneAlert = alertController.setDoneAlert(done: .dataSaved) { (doneButton) in
                            self.navigationController?.popViewController(animated: true)
                    }
                    self.present(doneAlert, animated: true, completion: nil)
                }
            }
        } else {
            let attentionAlert = alertController.setAttentionAlert(attention: .filedsAreNotFull, completion: nil)
            self.present(attentionAlert, animated: true, completion: nil)
        }
    }
    
    @objc func backButtonTouched(barButtonItem: UIBarButtonItem) {
        if AnyTextFieldIsFilled() {
            let attentionElert = alertController.setAttentionAlert(attention: .dataNotSaved) { (yesButton) in
                self.navigationController?.popViewController(animated: true)
            }
            self.present(attentionElert, animated: true, completion: nil)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    // -----------------------------------------------------
    // MARK: -View Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        creatNewBackButton()
        addTextFieldDelegate()
        addImagePickerDelegate()
        setTextFieldInput()
        
        if selectedWarranty != nil {
            setAsEditView()
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        unregisterObservers()
    }
    
    
    // -----------------------------------------------------
    // MARK: -Save Data
    
//    func contextHasChanged()-> Bool {
//        return dataController!.viewContext.hasChanges
//    }
    
    func calculatDays(years: Int, months: Int)-> Int {
        let daysInYears = years * 365
        let daysInMonths = months * 31
        
        return daysInYears + daysInMonths
    }
    
    func calculateEndDate()-> Date {
        return dateController.addToDate(date1: dateOfBuy, years: warrantyPeriodYears, months: warrantyPeriodMonths, days: 0)
    }
    
    func TextFieldsIsFilled()->Bool {
        if deviceNameTextField.text == "" || buyDateTextField.text == "" || warrantyPeriodTextField.text == "" || warrantyNumberTextField.text == "" || companyNameTextField.text == "" || supportNumberTextField.text == "" {
            return false
        } else {
            if warrantyImageView.image != nil {
                return true
            } else {
                return false
            }
        }
    }
    
    func AnyTextFieldIsFilled()-> Bool {
        if deviceNameTextField.text != "" || buyDateTextField.text != "" || companyNameTextField.text != "" || warrantyPeriodTextField.text != "" || warrantyNumberTextField.text != "" || supportNumberTextField.text != "" || warrantyImageView.image != nil {
            return true
        } else {
            return false
        }
    }
    
    func imageToData(image: UIImage)-> Data {
        return warrantyImageView.image!.jpegData(compressionQuality: 1.0)!
    }
    
    func saveData(completion: ()->Void) {
        let newWarranty = Warranty(context: dataController!.viewContext)
        
        // tack Data From UI
        let deviceName: String = deviceNameTextField.text!
        let dateOfBuy = self.dateOfBuy
        let warrantyPeriod: Int16 = Int16(calculatDays(years: warrantyPeriodYears, months: warrantyPeriodMonths))
        let warrantyNumber: String = warrantyNumberTextField.text!
        let compnayName: String = companyNameTextField.text!
        let supportNumber: String = supportNumberTextField.text!
        let endDate: Date = calculateEndDate()
        var remainingPeriod: Int16 = Int16(dateController.intervalBetweenDates(date1: Date(), date2: endDate))
        
        if remainingPeriod < 0 {
            remainingPeriod = Int16(0)
        }
            
            
        // write data to context
        newWarranty.devicName = deviceName
        newWarranty.buyDate = dateOfBuy
        newWarranty.warrantyPeriod = warrantyPeriod
        newWarranty.warrantyNumber = warrantyNumber
        newWarranty.companyName = compnayName
        newWarranty.supportNumber = supportNumber
        newWarranty.endDate = endDate
        newWarranty.remainingPeriod = remainingPeriod
        newWarranty.warrantyImage = imageToData(image: warrantyImageView.image!)
            
        // save Context
        do {
            try dataController?.viewContext.save()
            completion()
        } catch {
            let errorAlert = alertController.setErrorAlert(error: .contextNotSaved)
            self.present(errorAlert, animated: true, completion: nil)
        }
    }
    

    
    
    // -----------------------------------------------------
    //MARK: -Handle The Keyboard
    
    
    // it is deffrint between textField and another to deremain the spesfic height for the view when the keyboard show up
    var newYPoint: CGFloat = 0
    
    
    func hideKeyboard() {
        view.endEditing(true)
    }
    
    
    // Notfication Center
    func registerObservers() {
        // register keyboard will show observer
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
         // register keyboard frame did chamge observer
        NotificationCenter.default.addObserver(self, selector: #selector(keyboaredsFrameChanged(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
         // register keyboard sill hide observer
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unregisterObservers() {
        // unregister keyboard will show observer
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        
        // unregister keyboard will change frame observer
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)

        // unregister keyboard will hide observer
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        // pull the view up
        view.frame.origin.y = -newYPoint
    }
    
    @objc func keyboaredsFrameChanged(notification: Notification) {
        // pull the view up
        view.frame.origin.y = -newYPoint
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        view.frame.origin.y = 0
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        hideKeyboard()
    }
    
    
    
    
    // -----------------------------------------------------
    // MARK: -Handle Date Picker Inpute
    
    func setToolBar()-> UIToolbar {
        // set tool bar
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(toolBarDoneButtonTouched))
        toolBar.setItems([doneButton], animated: true)
        
        return toolBar
    }
    
    func setDatePickerInput()-> UIDatePicker {
        //set datePicker
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(datePicker:)), for: .valueChanged)
        datePicker.datePickerMode = .date

        return datePicker
    }
    
    func setTextFieldInput() {
        // for buyDate text filed set the date picker
        buyDateTextField.inputView = setDatePickerInput()
        buyDateTextField.inputAccessoryView = setToolBar()
        
        // for warrantyPeriod text field set the period picker
        warrantyPeriodTextField.inputView = setPeriodPicker()
        warrantyPeriodTextField.inputAccessoryView = setToolBar()
    }
    
    @objc func toolBarDoneButtonTouched() {
        self.view.endEditing(true)
    }
    
    @objc func datePickerValueChanged(datePicker: UIDatePicker) {
        buyDateTextField.text = dateController.stringFromDate(date: datePicker.date)
        dateOfBuy = datePicker.date
    }
    
    
    // -----------------------------------------------------
    // MARK: -Handle PeriodPicker Inpute
    
    func setPeriodPicker()-> UIPickerView {
        let periodPicker = UIPickerView()
        periodPicker.delegate = self
        periodPicker.dataSource = self
        
        return periodPicker
    }
    
    

    // -----------------------------------------------------
    // MARK: - Navigation
    
    // the reasons to do that is to add more actions to the back button
    
    func hideNavigationBackButton() {
        self.navigationItem.hidesBackButton = true
    }
    
    func creatNewBackButton() {
        let newBackButton = UIBarButtonItem(title: "الرجوع", style: .plain, target: self, action: #selector(backButtonTouched(barButtonItem:)))
        self.navigationItem.leftBarButtonItem = newBackButton
    }

}


// -----------------------------------------------------
// MARK: -Image Picker Extesion

extension AddThmanViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func showActionSheet() {
        let selectSourceSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // set Actions
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (cameraAction) in
            self.imagePicker.sourceType = .camera
            self.imagePicker.allowsEditing = true
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { (cameraAction) in
            self.imagePicker.sourceType = .photoLibrary
            self.imagePicker.allowsEditing = true
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        
        // add actons to the select source sheet
        selectSourceSheet.addAction(cameraAction)
        selectSourceSheet.addAction(photoLibraryAction)
        selectSourceSheet.addAction(cancelAction)
        
        self.present(selectSourceSheet, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let selectedImage = info[.originalImage] as! UIImage
        warrantyImageView.image = selectedImage
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    
    
}

// -----------------------------------------------------
// MARK: - Textfield Delegate
extension AddThmanViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    

    func textFieldDidBeginEditing(_ textField: UITextField) {
        //Get textField Height
        let textFieldHeight = textField.frame.height
        
        if textField == deviceNameTextField || textField == buyDateTextField {
            newYPoint = 0
        }
        if textField == warrantyPeriodTextField {
            newYPoint = textFieldHeight * 2
            registerObservers()
        }
        if textField == warrantyNumberTextField {
            newYPoint = ( textFieldHeight * 3 ) + 10
            registerObservers()
        }
        if textField == companyNameTextField {
            newYPoint = ( textFieldHeight * 4 ) + 20
            registerObservers()
        }
        if textField == supportNumberTextField {
            newYPoint = ( textFieldHeight * 5 )
            registerObservers()
        }
        
    }
    
}


// -----------------------------------------------------
// MARK: -Period Picker View Delegate & Data Source

extension AddThmanViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    // convert selected period to readable text
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
    
    
    // manage data source
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return 102
        } else {
            return 13
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            if row == 0 {
                return "السنوات"
            } else {
                return "\(row - 1)"
            }
        } else {
            if row == 0 {
                return "الشهور"
            } else {
                return "\(row - 1)"
            }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            warrantyPeriodYears = row - 1
        } else {
            warrantyPeriodMonths = row - 1
        }
        
        warrantyPeriodTextField.text = periodToText()
    }
    
}

