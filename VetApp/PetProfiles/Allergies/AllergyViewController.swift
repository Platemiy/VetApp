//
//  AllergyViewController.swift
//  VetApp
//
//  Created by Artemiy Platonov on 15.06.2020.
//  Copyright © 2020 Artemiy Platonov. All rights reserved.
//

import UIKit
import CoreData

class AllergyViewController: UIViewController {

    
    
    var pet: Pet?
    var dataSource: AllergyModelController = .init(allergies: [])
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = dataSource
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let ds = pet?.hasAllergy {
            dataSource.allergies = Array(ds).sorted(by: <).filter({ (allergy) -> Bool in
                return allergy.name != nil
            })
        }
        tableView.reloadData()
    }
    
    @IBAction func addAllergy(_ sender: Any) {
        let ac = UIAlertController(title: "Добавить аллергию", message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Добавить", style: .default) { (action) in
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
            let managedContext = appDelegate.persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "Allergy", in: managedContext)!
            let allergy = Allergy(entity: entity, insertInto: managedContext)
            if let displayOrder = self.pet?.hasAllergy?.count {
                allergy.displayOrder = Int16(displayOrder)
            }
            allergy.name = ac.textFields![0].text
            
            self.pet?.addToHasAllergy(allergy)
            self.dataSource.allergies.append(allergy)
            do {
                try managedContext.save()
            } catch {
                print("error")
            }
            self.tableView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        okAction.isEnabled = false
        ac.addTextField { (txt) in
            txt.placeholder = "Аллергия"
        }
        
        NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: ac.textFields?[0], queue: OperationQueue.main) { (notif) in
            let tf = ac.textFields?[0]
            okAction.isEnabled = !tf!.text!.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        }

        ac.addAction(okAction)
        ac.addAction(cancelAction)
        self.present(ac, animated: true, completion: nil)
    }
    
   

}
