//
//  HealthIssue+CoreDataClass.swift
//  VetApp
//
//  Created by Artemiy Platonov on 26.05.2020.
//  Copyright © 2020 Artemiy Platonov. All rights reserved.
//
//

import Foundation
import CoreData

@objc(HealthIssue)
public class HealthIssue: NSManagedObject {

}

extension HealthIssue: Comparable {
    public static func < (lhs: HealthIssue, rhs: HealthIssue) -> Bool {
        return lhs.displayOrder < rhs.displayOrder
    }
}
