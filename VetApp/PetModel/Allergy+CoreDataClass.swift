//
//  Allergy+CoreDataClass.swift
//  VetApp
//
//  Created by Artemiy Platonov on 26.05.2020.
//  Copyright © 2020 Artemiy Platonov. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Allergy)
public class Allergy: NSManagedObject {

}

extension Allergy: Comparable {
    public static func < (lhs: Allergy, rhs: Allergy) -> Bool {
        return lhs.displayOrder < rhs.displayOrder
    }
}
