//
//  AddProfileViewController.swift
//  VetApp
//
//  Created by Artemiy Platonov on 26.05.2020.
//  Copyright © 2020 Artemiy Platonov. All rights reserved.
//

import UIKit
import CoreData
import Firebase

class AddProfileViewController: UIViewController {

    @IBOutlet weak var petTypeChooser: UISegmentedControl!
    
    @IBOutlet weak var addedImage: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var breedTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var heightTextField: UITextField!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var addedPet: Pet?
    
    var isPhotoAdded: Bool = false
    
    var uid: String? {
        if let uid = UserDefaults.standard.value(forKey: "uid") as? String {
            return uid
        } else {
            return nil
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addedImage.roundedImage()
        self.hideKeyboardWhenTappedAround()
        setupAddTargetIsNotEmptyTextFields()

        
        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func setImage(_ sender: Any) {
        showImagePickerControllerActionSheet()
    }
    
    
    @IBAction func tapSaveButton(_ sender: UIBarButtonItem) {
        view.endEditing(true)
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Pet", in: managedContext)!
        let pet = Pet(entity: entity, insertInto: managedContext)
        let fetchRequest = NSFetchRequest<Pet>(entityName: "Pet")
        
        switch petTypeChooser.selectedSegmentIndex {
        case 0:
            pet.type = "dog"
            if !isPhotoAdded {
                addedImage.image = UIImage(named: "dogPlaceholder")
            }
        case 1:
            pet.type = "cat"
            if !isPhotoAdded {
                addedImage.image = UIImage(named: "catPlaceholder")
            }
        default:
            return
        }
        do {
            pet.displayOrder = Int16(try managedContext.count(for: fetchRequest))-1
        } catch {
            print("error")
        }
       
        pet.image = addedImage.image?.jpegData(compressionQuality: 0.0)
        pet.name = nameTextField.text
        pet.breed = breedTextField.text
        if let age = ageTextField.text, !age.isEmpty {
            pet.age = Int16(age) ?? 0
        }
        if let weight = weightTextField.text, !weight.isEmpty {
            pet.weight = Int16(weight) ?? 0
        }
        if let height = heightTextField.text, !height.isEmpty {
            pet.height = Int16(height) ?? 0
        }
        addedPet = pet
        do {
            try managedContext.save()
        } catch {
            print("error")
        }
        synchronizeFirebase()
        performSegue(withIdentifier: "saveadded", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? PetProfilesViewController, let pet = addedPet {
            dest.dataSource.pets.append(pet)
        }
    }
    
    func synchronizeFirebase() {
        let db = Firestore.firestore()
        if let uid = uid {
            guard let imageData = addedPet?.image else {
                return
            }
            let imgstr = imageData.base64EncodedString(options: .lineLength64Characters)
            print("added str: \(imgstr)")
            
            var age: Int = 0
            var weight: Int = 0
            var height: Int = 0
            if !ageTextField.text!.isEmpty {
                age = Int(ageTextField.text!)!
            }
            if !weightTextField.text!.isEmpty {
                weight = Int(weightTextField.text!)!
            }
            if !heightTextField.text!.isEmpty {
                height = Int(heightTextField.text!)!
            }
            let displayOrder: Int = Int(addedPet!.displayOrder)
            
            
            
            db.collection("users").document(uid).collection("pets").addDocument(data: ["type": petTypeChooser.selectedSegmentIndex, "displayOrder": displayOrder, "image": imgstr, "name": addedPet!.name!, "breed": addedPet!.breed!, "age": age, "weight": weight, "height": height])
            

        }
                
    }
    
    @IBAction func tapBack(_ sender: UIBarButtonItem) {
        view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func setupAddTargetIsNotEmptyTextFields() {
     saveButton.isEnabled = false //hidden okButton
     nameTextField.addTarget(self, action: #selector(textFieldIsNotEmpty),
                                 for: .editingChanged)
     breedTextField.addTarget(self, action: #selector(textFieldIsNotEmpty),
                                 for: .editingChanged)
        petTypeChooser.addTarget(self, action: #selector(textFieldIsNotEmpty), for: .valueChanged)
        ageTextField.addTarget(self, action: #selector(textFieldIsNotEmpty),
        for: .editingChanged)
     
    }

    
    
    @objc func textFieldIsNotEmpty(sender: Any) {

        if let texsender = sender as? UITextField {
            if texsender.text == " " {
                texsender.text = ""
            }
            
        }
        if ageTextField.text == "0" {
            ageTextField.text = ""
        }
        if weightTextField.text == "0" {
            weightTextField.text = ""
        }
        if heightTextField.text == "0" {
            heightTextField.text = ""
        }
        

     guard
       let name = nameTextField.text, !name.isEmpty,
       let breed = breedTextField.text, !breed.isEmpty,
        petTypeChooser.selectedSegmentIndex > -1
       else
     {
       self.saveButton.isEnabled = false
       return
     }
     saveButton.isEnabled = true
    }
    

}


extension AddProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    func showImagePickerControllerActionSheet() {
        let photoLibraryAction = UIAlertAction(title: "Фотоплёнка", style: .default) { (action) in
            self.showImagePickerController(sourceType: .photoLibrary)
        }
        
        let cameraAction = UIAlertAction(title: "Камера", style: .default) { (action) in
            self.showImagePickerController(sourceType: .camera)
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        
        AlertService.showAlert(style: .actionSheet, title: "Выбрать фото", message: nil, actions: [photoLibraryAction, cameraAction, cancelAction], completion: nil)
    }
    
    func showImagePickerController(sourceType: UIImagePickerController.SourceType) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        imagePickerController.sourceType = sourceType
        
        present(imagePickerController, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            addedImage.image = image
        } else {
            addedImage.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        }
        isPhotoAdded = true
        
        
        dismiss(animated: true, completion: nil)
    }
}
