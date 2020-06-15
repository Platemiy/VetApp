//
//  DogWalking+CoreDataClass.swift
//  VetApp
//
//  Created by Artemiy Platonov on 26.05.2020.
//  Copyright © 2020 Artemiy Platonov. All rights reserved.
//
//

import Foundation
import CoreData

@objc(DogWalking)
public class DogWalking: NSManagedObject {

}

extension DogWalking: Comparable {
    public static func < (lhs: DogWalking, rhs: DogWalking) -> Bool {
        return lhs.displayOrder < rhs.displayOrder
    }
}
