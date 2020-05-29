//
//  LogInButton.swift
//  VetApp
//
//  Created by Artemiy Platonov on 17.05.2020.
//  Copyright © 2020 Artemiy Platonov. All rights reserved.
//

import UIKit

@IBDesignable class FillednButton: UIButton {
    
    @IBInspectable var customColor: UIColor? = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1) {
        didSet {
            setupButton()
        } 
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }

    func setupButton() {
        backgroundColor = customColor
        setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
        layer.cornerRadius = super.frame.height / 2
        layer.borderWidth = 3.0
        layer.borderColor = customColor?.cgColor
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 3, height: 3)
        layer.shadowRadius = 3
        layer.shadowOpacity = 0.2
        //setTitle(titleLabel?.text?.uppercased(), for: .normal)
    }
}
