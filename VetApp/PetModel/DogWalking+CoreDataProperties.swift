//
//  DogWalking+CoreDataProperties.swift
//  VetApp
//
//  Created by Artemiy Platonov on 07.06.2020.
//  Copyright © 2020 Artemiy Platonov. All rights reserved.
//
//

import Foundation
import CoreData


extension DogWalking {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DogWalking> {
        return NSFetchRequest<DogWalking>(entityName: "DogWalking")
    }

    @NSManaged public var time: Date?
    @NSManaged public var displayOrder: Int16

}
