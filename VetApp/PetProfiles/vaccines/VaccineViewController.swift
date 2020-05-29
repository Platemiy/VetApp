//
//  VaccineViewController.swift
//  VetApp
//
//  Created by Artemiy Platonov on 29.05.2020.
//  Copyright © 2020 Artemiy Platonov. All rights reserved.
//

import UIKit
import CoreData

class VaccineViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    let dataSource: VaccineDataSource = .init(vaccines: [])

    
    var pet: Pet?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.dataSource = dataSource
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
       /* guard let appDel = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDel.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Vaccine>(entityName: "Vaccine")
        fetchRequest.predicate = NSPredicate(
        do {
            let  = try managedContext.fetch(fetchRequest).sorted(by: <)
            tableView.reloadData()
        } catch let error as NSError {
            print(error)
        }*/
    }
    

    @IBAction func addVaccine(_ sender: Any) {
        print("tapped")
                /*let entity = NSEntityDescription.entity(forEntityName: "Vaccine", in: managedContext)!
        let vaccine = Vaccine(entity: entity, insertInto: managedContext)
        pet?.addToNeedsVaccine(vaccine)
        vaccine.date = nil
        vaccine.name = ""
        vaccine.isAnnual = false */
        let fetchRequest = NSFetchRequest<Pet>(entityName: "Pet")
        if let d_o = pet?.displayOrder {
            print("d_o is here")

            //fetchRequest.predicate = NSPredicate(format: "displayOrder == %@", d_o)
            print("d_o is here too")

        }
        //fetchRequest.predicate = NSPredicate(format: "displayOrder == %@", pet!.displayOrder)
        print("but first: \(pet!.displayOrder)")
        
        
    }
    

}

