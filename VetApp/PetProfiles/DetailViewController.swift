//
//  DetailViewController.swift
//  VetApp
//
//  Created by Artemiy Platonov on 26.05.2020.
//  Copyright © 2020 Artemiy Platonov. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var petImage: UIImageView!
    @IBOutlet weak var petTypeImage: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var breedLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    
    var pet: Pet?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        petImage.image = UIImage(data: (pet?.image)!)
        petImage.roundedImage()
        switch pet!.type {
        case "dog" :
            petTypeImage.image = UIImage(named: "dogPlaceholder")
        case "cat" :
            petTypeImage.image = UIImage(named: "catPlaceholder")
        default:
            petTypeImage.backgroundColor = .white
        }
        nameLabel.text = pet?.name
        breedLabel.text = "Порода: \(pet?.breed ?? "")"
        if let age = pet?.realAge {
            ageLabel.text = "Возраст: \(age) лет"
        } else {
            ageLabel.text = "Возраст: "
        }
        if let weight = pet?.realWeight {
            weightLabel.text = "Вес: \(weight) кг"
        } else {
            weightLabel.text = "Вес: "
        }
        if let height = pet?.realHeight {
            heightLabel.text = "Рост: \(height) см"
        } else {
            heightLabel.text = "Рост: "
        }

    }
    
    @IBAction func saveEdited(_ seg: UIStoryboardSegue) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let editView = segue.destination as? EditProfileViewController {
            editView.pet = pet
        }
        if let vaccineView = segue.destination as? VaccineViewController {
            vaccineView.pet = pet
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
