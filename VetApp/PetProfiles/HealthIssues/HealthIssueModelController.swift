//
//  HealthIssueModelController.swift
//  VetApp
//
//  Created by Artemiy Platonov on 12.06.2020.
//  Copyright © 2020 Artemiy Platonov. All rights reserved.
//

import Foundation
import UIKit

class HealthIssueDataSource: NSObject {
    var issues = [HealthIssue]()
    
    init(issues: [HealthIssue]) {
        self.issues = issues
    }
}


extension HealthIssueDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return issues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Issue", for: indexPath) as! HealthIssueCell
        let issue = issues[indexPath.row]
        cell.issueDescription = issue.name
        cell.fromDate = issue.fromDate
        cell.toDate = issue.toDate
        return cell
    }
}

extension HealthIssueDataSource: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            let managedContext = appDelegate.persistentContainer.viewContext
            //let fetchRequest = NSFetchRequest<Pet>(entityName: "Pet")
           
            managedContext.delete(issues[indexPath.row])
            issues.remove(at: indexPath.row)
            for updatedIssueIndex in indexPath.row..<issues.count {
                issues[updatedIssueIndex].displayOrder = issues[updatedIssueIndex].displayOrder - 1
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

