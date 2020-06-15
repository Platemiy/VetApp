//
//  WalkingViewController.swift
//  VetApp
//
//  Created by Artemiy Platonov on 15.06.2020.
//  Copyright © 2020 Artemiy Platonov. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

class WalkingViewController: UIViewController {

    var pet: Pet?
    var dataSource: WalkingModelController = .init(walkings: [])
    
    @IBOutlet weak var tableView: UITableView!
    
    var timeTextField: UITextField?
    let datePicker = UIDatePicker()
    let toolbar = UIToolbar()
    let df = Utilities.readyTimeFormatter()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = dataSource
        // Do any additional setup after loading the view.
        datePicker.datePickerMode = .time
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.doneAction))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([flexSpace, doneButton], animated: true)
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let ds = pet?.hasToWalk {
            dataSource.walkings = Array(ds).sorted(by: <).filter({ (walking) -> Bool in
                return walking.time != nil
            })
        }
        tableView.reloadData()
    }
    
    
    @IBAction func addWalking(_ sender: Any) {
        let ac = UIAlertController(title: "Добавить выгул", message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Добавить", style: .default) { (action) in
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
            let managedContext = appDelegate.persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "DogWalking", in: managedContext)!
            let walking = DogWalking(entity: entity, insertInto: managedContext)
            if let displayOrder = self.pet?.hasToWalk?.count {
                walking.displayOrder = Int16(displayOrder)
            }
            walking.time = self.df.date(from: ac.textFields![0].text!)
            
            self.pet?.addToHasToWalk(walking)
            self.dataSource.walkings.append(walking)
            self.setupNotification(for: walking)
            do {
                try managedContext.save()
            } catch {
                print("error")
            }
        
            self.tableView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        okAction.isEnabled = false
        ac.addTextField { (txt) in
            self.timeTextField = txt
            self.timeTextField?.placeholder = "Время выгула"
            self.timeTextField?.inputView = self.datePicker
            self.timeTextField?.inputAccessoryView = self.toolbar
        }
        
        NotificationCenter.default.addObserver(forName: UITextField.textDidEndEditingNotification, object: ac.textFields?[0], queue: OperationQueue.main) { (notif) in
            let tf = ac.textFields?[0]
            okAction.isEnabled = !tf!.text!.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        }

        ac.addAction(okAction)
        ac.addAction(cancelAction)
        self.present(ac, animated: true, completion: nil)
    }

    @objc func doneAction(_ sender: Any) {
        timeTextField?.text = df.string(from: datePicker.date)
        timeTextField?.resignFirstResponder()
    }
    
    func setupNotification(for walking: DogWalking) {
        let content = UNMutableNotificationContent()
        content.title = "Выгул: \(pet!.name!)"
        content.body = "Время гулять!"
         
        let dateComponents =  Calendar.current.dateComponents([.hour, .minute], from: walking.time!)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let requestID = walking.objectID.uriRepresentation().absoluteString
        let request = UNNotificationRequest(identifier: requestID, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (err) in
            if let err = err {
                print(err.localizedDescription)
            }
        }
    }


}
