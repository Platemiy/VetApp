//
//  Pet+CoreDataClass.swift
//  VetApp
//
//  Created by Artemiy Platonov on 26.05.2020.
//  Copyright © 2020 Artemiy Platonov. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Pet)
public class Pet: NSManagedObject {
    
    var realAge: Int? {
        if age > 0 {
            return Int(age)
        } else {
            return nil
        }
    }
    
    var realWeight: Int? {
        if weight > 0 {
            return Int(weight)
        } else {
            return nil
        }
    }
    
    var realHeight: Int? {
        if height > 0 {
            return Int(height)
        } else {
            return nil
        }
    }
    
   
}

extension Pet: Comparable {
    public static func < (lhs: Pet, rhs: Pet) -> Bool {
        return lhs.displayOrder < rhs.displayOrder
    }
    

    
}
