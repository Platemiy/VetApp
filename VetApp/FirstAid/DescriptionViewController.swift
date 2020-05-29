//
//  DescriptionViewController.swift
//  VetApp
//
//  Created by Artemiy Platonov on 28.05.2020.
//  Copyright © 2020 Artemiy Platonov. All rights reserved.
//

import UIKit

class DescriptionViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    var text: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        textView.text = text
    }
    

 

}
