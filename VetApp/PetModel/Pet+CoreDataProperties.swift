//
//  Pet+CoreDataProperties.swift
//  VetApp
//
//  Created by Artemiy Platonov on 26.05.2020.
//  Copyright © 2020 Artemiy Platonov. All rights reserved.
//
//

import Foundation
import CoreData


extension Pet {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Pet> {
        return NSFetchRequest<Pet>(entityName: "Pet")
    }

    @NSManaged public var age: Int16
    @NSManaged public var breed: String?
    @NSManaged public var height: Int16
    @NSManaged public var name: String?
    @NSManaged public var type: String?
    @NSManaged public var weight: Int16
    @NSManaged public var image: Data?
    @NSManaged public var displayOrder: Int16
    @NSManaged public var hadHealthIssue: Set<HealthIssue>?
    @NSManaged public var hasAllergy: Set<Allergy>?
    @NSManaged public var hasToWalk: Set<DogWalking>?
    @NSManaged public var needsVaccine: Set<Vaccine>?

}

// MARK: Generated accessors for hadHealthIssue
extension Pet {

    @objc(addHadHealthIssueObject:)
    @NSManaged public func addToHadHealthIssue(_ value: HealthIssue)

    @objc(removeHadHealthIssueObject:)
    @NSManaged public func removeFromHadHealthIssue(_ value: HealthIssue)

    @objc(addHadHealthIssue:)
    @NSManaged public func addToHadHealthIssue(_ values: NSSet)

    @objc(removeHadHealthIssue:)
    @NSManaged public func removeFromHadHealthIssue(_ values: NSSet)

}

// MARK: Generated accessors for hasAllergy
extension Pet {

    @objc(addHasAllergyObject:)
    @NSManaged public func addToHasAllergy(_ value: Allergy)

    @objc(removeHasAllergyObject:)
    @NSManaged public func removeFromHasAllergy(_ value: Allergy)

    @objc(addHasAllergy:)
    @NSManaged public func addToHasAllergy(_ values: NSSet)

    @objc(removeHasAllergy:)
    @NSManaged public func removeFromHasAllergy(_ values: NSSet)

}

// MARK: Generated accessors for hasToWalk
extension Pet {

    @objc(addHasToWalkObject:)
    @NSManaged public func addToHasToWalk(_ value: DogWalking)

    @objc(removeHasToWalkObject:)
    @NSManaged public func removeFromHasToWalk(_ value: DogWalking)

    @objc(addHasToWalk:)
    @NSManaged public func addToHasToWalk(_ values: NSSet)

    @objc(removeHasToWalk:)
    @NSManaged public func removeFromHasToWalk(_ values: NSSet)

}

// MARK: Generated accessors for needsVaccine
extension Pet {

    @objc(addNeedsVaccineObject:)
    @NSManaged public func addToNeedsVaccine(_ value: Vaccine)

    @objc(removeNeedsVaccineObject:)
    @NSManaged public func removeFromNeedsVaccine(_ value: Vaccine)

    @objc(addNeedsVaccine:)
    @NSManaged public func addToNeedsVaccine(_ values: NSSet)

    @objc(removeNeedsVaccine:)
    @NSManaged public func removeFromNeedsVaccine(_ values: NSSet)

}
