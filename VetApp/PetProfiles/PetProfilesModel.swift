//
//  PetProfilesModel.swift
//  VetApp
//
//  Created by Artemiy Platonov on 25.05.2020.
//  Copyright © 2020 Artemiy Platonov. All rights reserved.
//

import Foundation

struct Pet {
    enum petType {
        case dog
        case cat
    }
    
    let type: petType
    var name: String
    var age: Int
    var breed: String
    var weight: Int?
    var height: Int?
    var healthIssues = [HealthIssue]()
    var vaccines = [Vaccine]()
    var dogWalkings = [DogWalking]()
    var allergies = [String]()
    
    init(type: petType, name: String, breed: String) {
        self.type = type
        self.name = name
        self.breed = breed
    }
    
    init(type: petType, name: String, breed: String, weight: Int) {
        self.type = type
        self.name = name
        self.breed = breed
    }
    
    
}
