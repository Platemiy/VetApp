//
//  AllergyCell.swift
//  VetApp
//
//  Created by Artemiy Platonov on 15.06.2020.
//  Copyright © 2020 Artemiy Platonov. All rights reserved.
//

import UIKit

class AllergyCell: UITableViewCell {

    
    @IBOutlet weak var allergyLabel: UILabel!
    
    var name: String? {
        didSet {
            allergyLabel.text = name
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {}

}
