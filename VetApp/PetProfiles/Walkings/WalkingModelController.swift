//
//  WalkingModelController.swift
//  VetApp
//
//  Created by Artemiy Platonov on 15.06.2020.
//  Copyright © 2020 Artemiy Platonov. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import UserNotifications

class WalkingModelController: NSObject {
    var walkings = [DogWalking]()
    
    init(walkings: [DogWalking]) {
        self.walkings = walkings
    }
}

extension WalkingModelController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return walkings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Walking", for: indexPath) as! WalkingCell
        let walking = walkings[indexPath.row]
        cell.walkingTime = walking.time
        return cell
    }
}

extension WalkingModelController: UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let deletingID = walkings[indexPath.row].objectID.uriRepresentation().absoluteString
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [deletingID])
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            let managedContext = appDelegate.persistentContainer.viewContext

            managedContext.delete(walkings[indexPath.row])
            walkings.remove(at: indexPath.row)
            for updatedWalkingIndex in indexPath.row..<walkings.count {
                walkings[updatedWalkingIndex].displayOrder = walkings[updatedWalkingIndex].displayOrder - 1
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
