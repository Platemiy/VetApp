//
//  PetTableViewCell.swift
//  VetApp
//
//  Created by Artemiy Platonov on 26.05.2020.
//  Copyright © 2020 Artemiy Platonov. All rights reserved.
//

import UIKit

class PetTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var breedLabel: UILabel!
    @IBOutlet weak var petImage: UIImageView!
    
    var name: String? {
        didSet {
            nameLabel.text = name
        }
    }
    
    var breed: String? {
        didSet {
            breedLabel.text = breed
        }
    }
    
    var petIMG: UIImage? {
        didSet {
            petImage.image = petIMG
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        petImage.roundedImage()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
