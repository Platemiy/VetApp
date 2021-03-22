//
//  VaccineModelController.swift
//  VetApp
//
//  Created by Artemiy Platonov on 29.05.2020.
//  Copyright © 2020 Artemiy Platonov. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications

class VaccineDataSource: NSObject {
    var vaccines: [Vaccine]
    
    init(vaccines: [Vaccine]) {
        self.vaccines = vaccines
    }
    
}




extension VaccineDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vaccines.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Vaccine", for: indexPath) as! VaccineCell
        let vaccine = vaccines[indexPath.row]
   
        cell.name = vaccine.name
        let df = DateFormatter()
        df.dateFormat = "dd.MM.yyyy"
        cell.isAnnualSwitch.isOn = vaccine.isAnnual
        if let date = vaccine.date {
            cell.date = df.string(from: date)
            if date < Date() {
                cell.isAnnualSwitch.isOn = false
                vaccine.isAnnual = false
                Utilities.saveContext()
            }
        } else {
            cell.date = nil
        }
        cell.vaccine = vaccine
        
        return cell
    }
    
    /*@objc func textFieldTarget(_ sender: Any) {
        
       } */
    
}

extension VaccineDataSource: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            let managedContext = appDelegate.persistentContainer.viewContext
            //let fetchRequest = NSFetchRequest<Pet>(entityName: "Pet")
            if vaccines[indexPath.row].isAnnual {
                let deletingID = vaccines[indexPath.row].objectID.uriRepresentation().absoluteString
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [deletingID])

            }
            managedContext.delete(vaccines[indexPath.row])
            vaccines.remove(at: indexPath.row)
            for updatedVaccineIndex in indexPath.row..<vaccines.count {
                vaccines[updatedVaccineIndex].displayOrder = vaccines[updatedVaccineIndex].displayOrder - 1
            }
            do {
                try managedContext.save()
            } catch {
                print ("error")
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
