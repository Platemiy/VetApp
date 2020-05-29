//
//  shadows.swift
//  VetApp
//
//  Created by Artemiy Platonov on 11.05.2020.
//  Copyright © 2020 Artemiy Platonov. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class ShadowImageView: UIImageView {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
    
    override func prepareForInterfaceBuilder() {
        super .prepareForInterfaceBuilder()
        setUp()
    }
    
    func setUp(){
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 5.0)
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 10
    }
}

@IBDesignable
class ShadowView: UIView {
    @IBInspectable var shadowColor: UIColor = UIColor.clear {
        didSet {
            layer.shadowColor = shadowColor.cgColor
        }
    }
    @IBInspectable var shadowRadius: CGFloat = 0.0 {
        didSet {
            layer.shadowRadius = shadowRadius
        }
    }
    @IBInspectable var shadowOpacity: CGFloat = 0.0 {
        didSet {
            layer.shadowOpacity = Float(shadowOpacity)
        }
    }
    @IBInspectable var shadowOffsetY: CGFloat = 0.0 {
        didSet {
            layer.shadowOffset.height = shadowOffsetY
        }
    }
}
