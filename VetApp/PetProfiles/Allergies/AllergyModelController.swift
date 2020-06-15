//
//  AllergyModelController.swift
//  VetApp
//
//  Created by Artemiy Platonov on 15.06.2020.
//  Copyright © 2020 Artemiy Platonov. All rights reserved.
//

import Foundation
import UIKit

class AllergyModelController: NSObject {
    var allergies = [Allergy]()
    
    init(allergies: [Allergy]) {
        self.allergies = allergies
    }
    
}

extension AllergyModelController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allergies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Allergy", for: indexPath) as! AllergyCell
        let allergy = allergies[indexPath.row]
        cell.name = allergy.name
        return cell
    }
}

extension AllergyModelController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
             guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                 return
             }
             let managedContext = appDelegate.persistentContainer.viewContext
            
             managedContext.delete(allergies[indexPath.row])
             allergies.remove(at: indexPath.row)
             for updatedIssueIndex in indexPath.row..<allergies.count {
                 allergies[updatedIssueIndex].displayOrder = allergies[updatedIssueIndex].displayOrder - 1
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
