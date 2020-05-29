//
//  AddGradient.swift
//  VetApp
//
//  Created by Artemiy Platonov on 18.05.2020.
//  Copyright © 2020 Artemiy Platonov. All rights reserved.
//

import UIKit

extension UIView {
    func addGradient(from firstColor: UIColor, to secondColor: UIColor) {
        
        let gradientLayer = CAGradientLayer()
     
        gradientLayer.frame = self.bounds
     
        gradientLayer.colors = [firstColor.cgColor, secondColor.cgColor]
        
        gradientLayer.locations = [0.0, 1.0]
     
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}
