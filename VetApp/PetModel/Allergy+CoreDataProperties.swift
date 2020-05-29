//
//  Allergy+CoreDataProperties.swift
//  VetApp
//
//  Created by Artemiy Platonov on 29.05.2020.
//  Copyright © 2020 Artemiy Platonov. All rights reserved.
//
//

import Foundation
import CoreData


extension Allergy {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Allergy> {
        return NSFetchRequest<Allergy>(entityName: "Allergy")
    }

    @NSManaged public var name: String?

}
