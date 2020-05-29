//
//  SignUpViewController.swift
//  VetApp
//
//  Created by Artemiy Platonov on 15.12.2019.
//  Copyright © 2019 Artemiy Platonov. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class SignUpViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    var uid: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        errorLabel.alpha = 0
        configureTextFields()
        configureTapGesture()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func tapSignupButton(_ sender: UIButton) {
        //validate fileds
        if let error = validateFields() {
            showError(error)
            return
        }
        
        let username = usernameTextField.text!.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        let email = emailTextField.text!.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!
        //create user
        Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
            
            //check for errors
            if err != nil {
                self.showError("Ошибка при создании пользователя")
                return
            }
            else {
                //user was created
                
                let db = Firestore.firestore()
            
                db.collection("users").document(result!.user.uid).setData(["username": username]) { (err) in
                    if err != nil {
                        self.showError("Ошибка в присвоении имени")
                        return
                }
                    //TODO: - handle when user is created but without username
                    UserDefaults.standard.setValue(result!.user.uid, forKey: "uid")
                    let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                    changeRequest?.displayName = username
                    changeRequest?.commitChanges(completion: { (err) in
                        if let err = err {
                            self.showError(err.localizedDescription)
                            return
                        }
                    })
                }
                //transition to homescreen
                UserDefaults.standard.setValue(result!.user.uid, forKey: "uid")
                UserDefaults.standard.set(true, forKey: "isLoggedIn")
                UserDefaults.standard.synchronize()
                self.transitionToHome()
            }
        }
        
    }
    
    //if nil then data is valid, otherwise return error message
    func validateFields() -> String? {
        //check that all field are filled
        if usernameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
        {
            return "Заполните все поля"
        }
        
        //username validation
        if Utilities.isUsernameValid(usernameTextField.text!.lowercased()) == false {
            return "Некорректное имя пользователя"
        }
        
        //email validation
        if Utilities.isEmailValid(emailTextField.text!.lowercased()) == false {
            return "некорректный адрес электронной почты"
        }
        
        //password validation
        let cleanPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if Utilities.isPasswordValid(cleanPassword) == false {
            return "Убедитесь что пароль состоит из минимум 6 знаков, среди которых есть латинские буквы, цифры и специальные знаки"
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
    
    
    private func configureTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.handleTap))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTap() {
        view.endEditing(true)
    }
    
    private func configureTextFields() {
        usernameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }

  

}

extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
           nextField.becomeFirstResponder()
        } else {
           // Not found, so remove keyboard.
           textField.resignFirstResponder()
        }
        return false
    }
}
