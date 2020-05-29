//
//  LogInViewController.swift
//  VetApp
//
//  Created by Artemiy Platonov on 15.12.2019.
//  Copyright © 2019 Artemiy Platonov. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import CoreData

class LogInViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    let userDefault = UserDefaults.standard
    let launchedBefore = UserDefaults.standard.bool(forKey: "usersignedin")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        errorLabel.alpha = 0
            configureTextFields()
            configureTapGesture()
            // Do any additional setup after loading the view.
        }
    
    @IBAction func tapLoginButton(_ sender: UIButton) {
        //validate field
        if let error = validateFields() {
            showError(error)
            return
        }
        
        let email = emailTextField.text!
        let password = passwordTextField.text!
        
        //sign in
        Auth.auth().signIn(withEmail: email, password: password) { (result, err) in
            if err != nil {
                
                self.showError("Неверный логин или пароль")
                return
            } else {
                UserDefaults.standard.setValue(result!.user.uid, forKey: "uid")
                UserDefaults.standard.set(true, forKey: "isLoggedIn")
                UserDefaults.standard.synchronize()
                self.synchronizeFirebase()
                self.transitionToHome()
            }
        }
    }
    
    func validateFields() -> String? {
        //check that all field are filled
        if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
        {
            return "Заполните все поля"
        }
        return nil
    }
    
    private func showError(_ errorMessage: String){
        errorLabel.text = errorMessage
        errorLabel.alpha = 1
        view.endEditing(true)
    }
    
    func transitionToHome() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let homeViewController = mainStoryboard.instantiateViewController(withIdentifier: Constants.Storyboard.homeView) as? UITabBarController
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }
    
    func synchronizeFirebase() {
        if let uid = Auth.auth().currentUser?.uid {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            let managedContext = appDelegate.persistentContainer.viewContext
            let petsRef = Firestore.firestore().collection("users").document("\(uid)").collection("pets")
            petsRef.getDocuments { (snapshot, err) in
                if let err = err {
                    print(err.localizedDescription)
                } else {
                    for doc in snapshot!.documents {
                        let entity = NSEntityDescription.entity(forEntityName: "Pet", in: managedContext)!
                        let pet = Pet(entity: entity, insertInto: managedContext)
                         
                        switch doc.data()["type"] as! Int{
                         case 0:
                             pet.type = "dog"
                           
                         case 1:
                             pet.type = "cat"
                         default:
                             return
                         }
                        pet.displayOrder = Int16(doc.data()["displayOrder"] as! Int)
                        
                        let imgstr = doc.data()["image"] as! String
                        print("login string: \(imgstr)")
                        let imgdata = Data(base64Encoded: imgstr, options: Data.Base64DecodingOptions.ignoreUnknownCharacters)
                        print(String(describing: imgdata))
                        pet.image = Data(base64Encoded: imgstr, options: Data.Base64DecodingOptions.ignoreUnknownCharacters)
                        pet.name = doc.data()["name"] as! String
                        pet.breed = doc.data()["breed"] as! String
                        pet.age = Int16(doc.data()["age"] as! Int)
                        pet.weight = Int16(doc.data()["weight"] as! Int)
                        pet.height = Int16(doc.data()["height"] as! Int)

                         do {
                             try managedContext.save()
                         } catch {
                             print("error")
                         }
                    }
                }
            }
        }
    }
        
    private func configureTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.handleTap))
            view.addGestureRecognizer(tapGesture)
    }
        
    @objc func handleTap() {
        view.endEditing(true)
    }
    
    private func configureTextFields() {
           emailTextField.delegate = self
           passwordTextField.delegate = self
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

extension LogInViewController: UITextFieldDelegate {
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
