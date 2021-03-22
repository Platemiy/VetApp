//
//  PetProfilesViewController.swift
//  VetApp
//
//  Created by Artemiy Platonov on 25.05.2020.
//  Copyright © 2020 Artemiy Platonov. All rights reserved.
//

import UIKit
import FirebaseAuth
import CoreData

class PetProfilesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let dataSource: PetsDataSource = .init(pets: [])
    
    var uid: String? {
        if let uid = UserDefaults.standard.value(forKey: "uid") as? String {
            return uid
        } else {
            return nil
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = dataSource
        let nav = self.navigationController
        let tab = nav?.tabBarController
        tab?.selectedIndex = 1

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let index = tableView.indexPathForSelectedRow {
            self.tableView.deselectRow(at: index, animated: false)
        }
        
        guard let appDel = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDel.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Pet>(entityName: "Pet")
        
        do {
            dataSource.pets = try managedContext.fetch(fetchRequest).sorted(by: <)
            tableView.reloadData()
        } catch let error as NSError {
            print(error)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let row = tableView.indexPathForSelectedRow?.row {
            let selectedPet = dataSource.pets[row]
            (segue.destination as? DetailViewController)?.pet = selectedPet
        }
    }
    
     
    @IBAction func saveAddedPet(_ seg: UIStoryboardSegue) {
        
    }
    
    
    @IBAction func signOut(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
        } catch let error as NSError {
            print("error signing out: %@", error.localizedDescription)
        }
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
        UserDefaults.standard.synchronize()
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Pet")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try managedContext.execute(deleteRequest)
        } catch {
            print("error")
        }
        let authStoryboard = UIStoryboard(name: "Auth", bundle: nil)
        let homeAuthViewController = authStoryboard.instantiateViewController(withIdentifier: Constants.Storyboard.rootScreen) as? UINavigationController
        view.window?.rootViewController = homeAuthViewController
        view.window?.makeKeyAndVisible()
        
    }
    

    
    


}
