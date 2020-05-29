//
//  EditProfileViewController.swift
//  VetApp
//
//  Created by Artemiy Platonov on 26.05.2020.
//  Copyright © 2020 Artemiy Platonov. All rights reserved.
//

import UIKit
import Firebase

class EditProfileViewController: UIViewController {

    var pet: Pet?
    
    @IBOutlet weak var petImage: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var breedTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var photoPlaceholder: UIImageView!
    
    var uid: String? {
        if let uid = UserDefaults.standard.value(forKey: "uid") as? String {
            return uid
        } else {
            return nil
        }
    }
    
    var isPhotoEdited = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        petImage.image = UIImage(data: (pet?.image)!)
        petImage.roundedImage()
        photoPlaceholder.roundedImage()
        nameTextField.text = pet?.name
        breedTextField.text = pet?.breed
        
        
        if let age = pet?.realAge {
            ageTextField.text = "\(age)"
        }
        if let weight = pet?.realWeight {
            weightTextField.text = "\(weight)"
        }
        if let height = pet?.realHeight {
            heightTextField.text = "\(height)"
        }
        //weightTextField.text = String(pet?.weight)
        //heightTextField.text = String(pet?.height)

    }
    
    
    
    @IBAction func setImage(_ sender: Any) {
        showImagePickerControllerActionSheet()
    }
    
    
    @IBAction func saveEdit(_ sender: Any) {
        if isPhotoEdited {
            pet?.image = petImage.image?.jpegData(compressionQuality: 0.0)
        }
        pet?.name = nameTextField.text
        pet?.breed = breedTextField.text
        if let age = ageTextField.text, !age.isEmpty {
            pet?.age = Int16(age) ?? 0
        } else {
            pet?.age = 0
        }
        if let weight = weightTextField.text, !weight.isEmpty {
            pet?.weight = Int16(weight) ?? 0
        } else {
            pet?.weight = 0
        }
        if let height = heightTextField.text, !height.isEmpty {
            pet?.height = Int16(height) ?? 0
        } else {
            pet?.height = 0
        }
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        do {
            try managedContext.save()
        } catch {
            print("error")
        }
        synchronizeFirebase()
        performSegue(withIdentifier: "saveedited", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? DetailViewController {
            dest.pet = pet
        }
    }
    
    func synchronizeFirebase() {
        let db = Firestore.firestore()
        if let uid = uid{
            let petsRef = db.collection("users").document("\(uid)").collection("pets")
            let query = petsRef.whereField("displayOrder", isEqualTo: pet!.displayOrder)
            query.getDocuments { (doc, err) in
                if err != nil {
                    print(err!.localizedDescription)
                } else if doc!.documents.count != 1 {
                    print("error")
                } else {

                    var age: Int = 0
                    var weight: Int = 0
                    var height: Int = 0
                    if !self.ageTextField.text!.isEmpty {
                        age = Int(self.ageTextField.text!)!
                    }
                    if !self.weightTextField.text!.isEmpty {
                        weight = Int(self.weightTextField.text!)!
                    }
                    if !self.heightTextField.text!.isEmpty {
                        height = Int(self.heightTextField.text!)!
                    }
                    
                    doc!.documents.first!.reference.updateData(["name": self.pet!.name!, "breed": self.pet!.breed!, "age": age, "weight": weight, "height": height])
                    if self.isPhotoEdited {
                        guard let imageData = self.pet?.image else {
                            return
                        }
                        let imgstr = imageData.base64EncodedString(options: .lineLength64Characters)
                        doc!.documents.first!.reference.updateData(["image": imgstr])
                    }
                    }
                    
                }
            }
        }
    
}


extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
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
            petImage.image = image
        } else {
            petImage.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        }
        isPhotoEdited = true
        
        
        dismiss(animated: true, completion: nil)
    }
}
