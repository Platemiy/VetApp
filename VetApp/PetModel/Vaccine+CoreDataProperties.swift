//
//  Vaccine+CoreDataProperties.swift
//  VetApp
//
//  Created by Artemiy Platonov on 07.06.2020.
//  Copyright © 2020 Artemiy Platonov. All rights reserved.
//
//

import Foundation
import CoreData


extension Vaccine {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Vaccine> {
        return NSFetchRequest<Vaccine>(entityName: "Vaccine")
    }

    @NSManaged public var date: Date?
    @NSManaged public var isAnnual: Bool
    @NSManaged public var name: String?
    @NSManaged public var displayOrder: Int16

}
