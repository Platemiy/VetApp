//
//  HealthIssueCell.swift
//  VetApp
//
//  Created by Artemiy Platonov on 12.06.2020.
//  Copyright © 2020 Artemiy Platonov. All rights reserved.
//

import UIKit

class HealthIssueCell: UITableViewCell {
    
    let df = Utilities.readyDateFormatter()

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var toLabel: UILabel!
    
    var issueDescription: String? {
        didSet {
            descriptionLabel.text = issueDescription
        }
    }
    
    var fromDate: Date? {
        didSet {
            if let fromDate = fromDate {
                fromLabel.text = df.string(from: fromDate)
            }
        }
    }
    
    var toDate: Date? {
        didSet {
            if let toDate = toDate {
                toLabel.text = df.string(from: toDate)
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {}

}
