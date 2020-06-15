//
//  WalkingCell.swift
//  VetApp
//
//  Created by Artemiy Platonov on 15.06.2020.
//  Copyright © 2020 Artemiy Platonov. All rights reserved.
//

import UIKit

class WalkingCell: UITableViewCell {

    let df = Utilities.readyTimeFormatter()
    
    @IBOutlet weak var timeLabel: UILabel!
    
    var walkingTime: Date? {
        didSet {
            if let date = walkingTime {
                timeLabel.text = "выгул в \(df.string(from: date))"
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {}

}
