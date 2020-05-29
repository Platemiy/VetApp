//
//  HealthIssue+CoreDataProperties.swift
//  VetApp
//
//  Created by Artemiy Platonov on 29.05.2020.
//  Copyright © 2020 Artemiy Platonov. All rights reserved.
//
//

import Foundation
import CoreData


extension HealthIssue {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<HealthIssue> {
        return NSFetchRequest<HealthIssue>(entityName: "HealthIssue")
    }

    @NSManaged public var fromDate: Date?
    @NSManaged public var name: String?
    @NSManaged public var toDate: Date?

}
