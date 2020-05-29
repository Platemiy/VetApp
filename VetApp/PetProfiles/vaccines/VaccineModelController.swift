//
//  VaccineModelController.swift
//  VetApp
//
//  Created by Artemiy Platonov on 29.05.2020.
//  Copyright © 2020 Artemiy Platonov. All rights reserved.
//

import Foundation
import UIKit

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
        df.dateFormat = "dd.mm.yyyy"
        if let date = vaccine.date {
            cell.date = df.string(from: date)
        }
        
        cell.isAnnualSwitch.isOn = vaccine.isAnnual
        
        return cell
    }
    
    
}
