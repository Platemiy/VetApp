//
//  DogWalking+CoreDataProperties.swift
//  VetApp
//
//  Created by Artemiy Platonov on 29.05.2020.
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

}
