//
//  petModelController.swift
//  VetApp
//
//  Created by Artemiy Platonov on 26.05.2020.
//  Copyright © 2020 Artemiy Platonov. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import Firebase
import UserNotifications

class PetsDataSource: NSObject {
    var pets: [Pet]
    
    init(pets: [Pet]) {
        self.pets = pets.sorted(by: <)
    }
    
}

extension PetsDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Pet", for: indexPath) as! PetTableViewCell
        let pet = pets[indexPath.row]
        cell.name = pet.name
        cell.breed = pet.breed
        cell.petIMG = pet.image?.convert()
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    
}

extension PetsDataSource: UITableViewDelegate {
    var uid: String? {
        if let uid = UserDefaults.standard.value(forKey: "uid") as? String {
            return uid
        } else {
            return nil
        }
    }

    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            let managedContext = appDelegate.persistentContainer.viewContext
            //let fetchRequest = NSFetchRequest<Pet>(entityName: "Pet")
            //delete vaccine notifications
            if let vaccines = pets[indexPath.row].needsVaccine {
                var ids = [String]()
                for vaccine in vaccines {
                    if vaccine.isAnnual {
                        ids.append(vaccine.objectID.uriRepresentation().absoluteString)
                    }
                }
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ids)
            }
            if pets[indexPath.row].breed == "dog" {
                if let walkings = pets[indexPath.row].hasToWalk {
                    var ids = [String]()
                    for walking in walkings {
                        ids.append(walking.objectID.uriRepresentation().absoluteString)
                        
                    }
                    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ids)
                }
            }
            
            
            managedContext.delete(pets[indexPath.row])
            pets.remove(at: indexPath.row)
            for updatedPetIndex in indexPath.row..<pets.count {
                pets[updatedPetIndex].displayOrder = pets[updatedPetIndex].displayOrder - 1
            }
            do {
                try managedContext.save()
            } catch {
                print ("error")
            }
            synchronizeFirebase(index: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func synchronizeFirebase(index: Int) {
        if let uid = uid {
            let petsRef = Firestore.firestore().collection("users").document("\(uid)").collection("pets")
            let removeQuery = petsRef.whereField("displayOrder", isEqualTo: index)
            let updateQuery = petsRef.whereField("displayOrder", isGreaterThan: index)
            removeQuery.getDocuments { (doc, err) in
                if let err = err {
                    print(err.localizedDescription)
                } else if doc!.count != 1 {
                    print("too many objects")
                } else {
                    doc!.documents.first!.reference.delete()
                    updateQuery.getDocuments { (upddoc, err) in
                        if let err = err {
                            print(err.localizedDescription)
                        } else {
                            for doc in upddoc!.documents {
                                let newDO = doc.data()["displayOrder"] as! Int - 1
                                doc.reference.updateData(["displayOrder": newDO])
                            }
                        }
                    }
                }
            }
        }
        
    }
}
