//
//  UIImageViewExtensions.swift
//  VetApp
//
//  Created by Artemiy Platonov on 25.05.2020.
//  Copyright © 2020 Artemiy Platonov. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    func roundedImage() {
        self.layer.cornerRadius = self.frame.width / 2
        self.clipsToBounds = true
    }
}

extension Data {
    func convert() -> UIImage? {
        return UIImage(data: self)
    }
}
