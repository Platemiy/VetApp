//
//  Vaccine+CoreDataClass.swift
//  VetApp
//
//  Created by Artemiy Platonov on 26.05.2020.
//  Copyright © 2020 Artemiy Platonov. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Vaccine)
public class Vaccine: NSManagedObject {

}

extension Vaccine: Comparable {
    public static func < (lhs: Vaccine, rhs: Vaccine) -> Bool {
        return lhs.displayOrder < rhs.displayOrder
    }
}
