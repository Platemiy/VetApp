//
//  SolutionCell.swift
//  VetApp
//
//  Created by Artemiy Platonov on 28.05.2020.
//  Copyright © 2020 Artemiy Platonov. All rights reserved.
//

import UIKit

class SolutionDogCell: UITableViewCell {

    @IBOutlet weak var problemLabel: UILabel!
    
    var problem: String? {
        didSet {
            problemLabel.text = problem
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
