//
//  Utilities.swift
//  VetApp
//
//  Created by Artemiy Platonov on 20.05.2020.
//  Copyright © 2020 Artemiy Platonov. All rights reserved.
//

import Foundation
import  UIKit

struct Utilities {
    static func isPasswordValid(_ password: String?) -> Bool {
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{6,}")
        return passwordTest.evaluate(with: password)
    }
    
    static func isEmailValid(_ email: String?) -> Bool {
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
        return passwordTest.evaluate(with: email)
    }
    
    static func isUsernameValid(_ username: String?) -> Bool {
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^[a-z0-9_-]{3,16}$")
        return passwordTest.evaluate(with: username)
    }
    
    static func saveContext() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        do {
            try managedContext.save()
        } catch {
            print("error")
        }
    }
   
    static func readyDateFormatter() -> DateFormatter {
        let df = DateFormatter()
        df.dateFormat = "dd.MM.yyyy"
        return df
    }
    
    static func readyTimeFormatter() -> DateFormatter {
        let df = DateFormatter()
        df.dateFormat = "HH:mm"
        return df
    }
}


