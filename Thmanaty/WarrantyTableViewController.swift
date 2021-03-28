//
//  ThmanatTableViewController.swift
//  Thmanat
//
//  Created by Mohammed Alessi on 25/01/1442 AH.
//  Copyright © 1442 Mohammed Alessi. All rights reserved.
//

import UIKit
import CoreData

class WarrantyTableViewController: UITableViewController {

    var warranties: [Warranty]!
    var dataController: DataController?
    var alertController: AlertController = AlertController()
    var dateController: DateController = DateController()
    var selectedWarranty: Warranty?
    
    // ------------------------------------------------------------
    // MARK: -Fetch Data from coreData
    
    func getData() {
        let fetchRequest: NSFetchRequest<Warranty> = Warranty.fetchRequest()
        let sortDecriptore: NSSortDescriptor = NSSortDescriptor(key: "remainingPeriod", ascending: true)
        fetchRequest.sortDescriptors = [sortDecriptore]
        
        do {
            warranties = try dataController?.viewContext.fetch(fetchRequest)
            reloadTableView()
        } catch {
            let errorAlert = alertController.setErrorAlert(error: .dataNotFound)
            self.present(errorAlert, animated: true, completion: nil)
        }
        
    }
    
    func updateData() {
        getData()
        reloadTableView()
    }
    
    func updatePeriods() {
        for warranty in warranties {
            warranty.remainingPeriod = Int16(dateController.intervalBetweenDates(date1: Date(), date2: warranty.endDate!))
            if warranty.remainingPeriod < 0 {
                warranty.remainingPeriod = 0
            }
            do {
                try warranty.managedObjectContext?.save()
            } catch {
                
            }
        }
        getData()
    }
    
    
    // ------------------------------------------------------------
    // MARK: -View Cycels
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        reloadTableView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        updateData()
        updatePeriods()
    }
    
    // ------------------------------------------------------------
    // MARK: -Navigation
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
//    }


    
    // ------------------------------------------------------------
    // MARK: -Table View DataSource
    func reloadTableView() {
        self.tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return warranties.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "thmanCell") as! WarrantyTableViewCell
        cell.setWarrantyCell(warranty: warranties[indexPath.row])
        
        return cell
    }

    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 145
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedWarranty = warranties[indexPath.row]
        let viewThmanVC = self.storyboard?.instantiateViewController(withIdentifier: "viewThman") as! ViewThmanViewController
        viewThmanVC.modalPresentationStyle = .fullScreen
        viewThmanVC.selectedWarranty = self.selectedWarranty
        self.navigationController?.pushViewController(viewThmanVC, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            dataController?.viewContext.delete(warranties[indexPath.row])
            warranties.remove(at: indexPath.row)
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
            do {
                try dataController?.viewContext.save()
            } catch {
                let errorAlert = alertController.setErrorAlert(error: .someError)
                self.present(errorAlert, animated: true, completion: nil)
            }
            
        }
    }
    
}
