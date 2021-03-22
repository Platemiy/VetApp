//
//  VaccineCell.swift
//  VetApp
//
//  Created by Artemiy Platonov on 29.05.2020.
//  Copyright © 2020 Artemiy Platonov. All rights reserved.
//

import UIKit
import UserNotifications

class VaccineCell: UITableViewCell {
    
    var vaccine: Vaccine?
    let datePicker = UIDatePicker()

    let df = Utilities.readyDateFormatter()

    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    
    @IBOutlet weak var isAnnualSwitch: UISwitch!
    
    var name: String? {
        didSet {
            nameTextField.text = name
        }
    }
    
    var date: String? {
        didSet {
            if let date = date {
                dateTextField.text = date
            } else {
                dateTextField.text = nil
            }
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        datePicker.datePickerMode = .date
        datePicker.minimumDate = Date(timeIntervalSinceNow: 86400)
        datePicker.date = datePicker.minimumDate!
        dateTextField.inputView = datePicker
        
        
        
        let toolbar = UIToolbar()
        
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneAction))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([flexSpace, doneButton], animated: true)
        dateTextField.inputAccessoryView = toolbar
        
        datePicker.addTarget(self, action: #selector(textFieldTarget), for: .valueChanged)
        nameTextField.addTarget(self, action: #selector(textFieldTarget),
        for: .editingChanged)
        //dateTextField.addTarget(self, action: #selector(dateTextFieldTarget),
        //for: .editingChanged)
        dateTextField.addTarget(self, action: #selector(dateTextFieldTarget),
                             for: .editingChanged)
        isAnnualSwitch.addTarget(self, action: #selector(flipSwitch),
                                      for: .valueChanged)
        // Initialization code
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        self.addGestureRecognizer(tap)
        nameTextField.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {

        // Configure the view for the selected state
    }
    

    
    @objc func flipSwitch(_ sender: UISwitch) {
        if dateTextField.text!.isEmpty {
            isAnnualSwitch.isOn = false
            isAnnualSwitch.isSelected = false
            isAnnualSwitch.isHighlighted = false
            isAnnualSwitch.isEnabled = false
            return
        }
        
        vaccine?.isAnnual = sender.isOn
        Utilities.saveContext()

        
        
        if sender.isOn && !dateTextField.text!.isEmpty  {
            let content = UNMutableNotificationContent()
            content.title = nameTextField.text!
            content.body = "Завтра у вас запланирована прививка"
            let currentDate = Date()
            let currentCalendar = Calendar.current
            let hours = currentCalendar.component(.hour, from: currentDate)
            let minutes = currentCalendar.component(.minute, from: currentDate)
            let seconds = currentCalendar.component(.second, from: currentDate)

            
            let notificationDate = currentCalendar.date(bySettingHour: hours, minute: minutes, second: seconds+5, of: (vaccine?.date)!)!
            
            var dateComponents =  Calendar.current.dateComponents([.day, .month, .hour, .minute, .second], from: notificationDate)
            dateComponents.day! -= 1
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            
            let requestID = vaccine!.objectID.uriRepresentation().absoluteString
            print("from flip: \(vaccine!.objectID.uriRepresentation().absoluteString)")

            
            let request = UNNotificationRequest(identifier: requestID, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request) { (err) in
                if let err = err {
                    print("error flip: \(self.vaccine!.objectID.uriRepresentation().absoluteString)")

                    print(err.localizedDescription)
                }
            }
            UNUserNotificationCenter.current().getPendingNotificationRequests { (notif) in
                for n in notif {
                    print(n.content.body)
                    print(n.trigger!.debugDescription)
                    
                }
            }
        }
        else if !sender.isOn && !dateTextField.text!.isEmpty {
            if vaccine!.date != nil {

                let oldID = vaccine!.objectID.uriRepresentation().absoluteString

                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [oldID])
            }
            
        }
        
    }
    
    @objc func textFieldTarget(_ sender: Any) {
        if vaccine!.date != nil && isAnnualSwitch.isOn {
            let oldID = vaccine!.objectID.uriRepresentation().absoluteString
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [oldID])
        }
        isAnnualSwitch.isOn = false
        vaccine!.isAnnual = false
        vaccine!.name = nameTextField.text!
        Utilities.saveContext()
    }
    
    @objc func dateTextFieldTarget(_ sender: Any) {
        
        if vaccine!.date != nil && isAnnualSwitch.isOn {

            let oldID = vaccine!.objectID.uriRepresentation().absoluteString
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [oldID])
        }
        
        isAnnualSwitch.isEnabled = true
        isAnnualSwitch.isOn = false

        vaccine!.date = datePicker.date
        vaccine!.isAnnual = false
        print("from target: \(vaccine!.objectID.uriRepresentation().absoluteString)")

        Utilities.saveContext()
        
        
        

    }
    
    @objc func doneAction(_ sender: Any) {

        dateTextField.text = df.string(from: datePicker.date)
        print("from done: \(vaccine!.objectID.uriRepresentation().absoluteString)")
        if vaccine!.date != nil && isAnnualSwitch.isOn {

                   let oldID = vaccine!.objectID.uriRepresentation().absoluteString
                   UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [oldID])
               }
               
               isAnnualSwitch.isEnabled = true
               isAnnualSwitch.isOn = false

               vaccine!.date = datePicker.date
               vaccine!.isAnnual = false
               Utilities.saveContext()
        self.endEditing(true)
    }
    
    

}

extension VaccineCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.endEditing(true)
        return false
    }
}
