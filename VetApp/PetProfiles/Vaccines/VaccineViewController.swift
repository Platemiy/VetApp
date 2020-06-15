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
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        let tabletap = UITapGestureRecognizer(target: self.tableView, action: #selector(UIView.endEditing))
        tabletap.cancelsTouchesInView = false
        tableView.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let ds = pet?.needsVaccine {
            dataSource.vaccines = Array(ds).sorted(by: <).filter({ (vac) -> Bool in
                return vac.name != nil
            })
        }
        tableView.reloadData()
    }
    

    @IBAction func addVaccine(_ sender: Any) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Vaccine", in: managedContext)!
        let vaccine = Vaccine(entity: entity, insertInto: managedContext)
        pet?.addToNeedsVaccine(vaccine)
        if let displayOrder = pet?.needsVaccine?.count {
            vaccine.displayOrder = Int16(displayOrder)
        }
        vaccine.date = nil
        vaccine.name = ""
        vaccine.isAnnual = false
        dataSource.vaccines.append(vaccine)
        do {
            try managedContext.save()
        } catch {
            print("error")
        }
        tableView.reloadData()
    }
    
   
    
    

}

