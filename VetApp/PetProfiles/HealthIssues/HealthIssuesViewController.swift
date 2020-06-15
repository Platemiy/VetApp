//
//  HealthIssuesViewController.swift
//  VetApp
//
//  Created by Artemiy Platonov on 12.06.2020.
//  Copyright © 2020 Artemiy Platonov. All rights reserved.
//

import UIKit
import NotificationCenter
import CoreData

class HealthIssuesViewController: UIViewController {

    var descriptionTextField: UITextField?
    var fromDateTextField: UITextField?
    var toDateTextField: UITextField?

    var dateTextField: UITextField?
    let fromDatePicker = UIDatePicker()
    let toDatePicker = UIDatePicker()
    let toolbar = UIToolbar()

    
    let df = Utilities.readyDateFormatter()
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var pet: Pet?
    
    let dataSource: HealthIssueDataSource = .init(issues: [])

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = dataSource
        
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.doneAction))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([flexSpace, doneButton], animated: true)
        // Do any additional setup after loading the view.
        fromDatePicker.datePickerMode = .date
        toDatePicker.datePickerMode = .date
        fromDatePicker.maximumDate = toDatePicker.date
        toDatePicker.minimumDate = fromDatePicker.date
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
  
        if let ds = pet?.hadHealthIssue {
            dataSource.issues = Array(ds).sorted(by: <).filter({ (issue) -> Bool in
                return issue.name != nil
            })
        }
        tableView.reloadData()
        
    }
    
    @IBAction func addIssue(_ sender: Any) {
        let ac = UIAlertController(title: "Добавить случай", message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Добавить", style: .default) { (action) in
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
            let managedContext = appDelegate.persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "HealthIssue", in: managedContext)!
            let issue = HealthIssue(entity: entity, insertInto: managedContext)
            if let displayOrder = self.pet?.hadHealthIssue?.count {
                issue.displayOrder = Int16(displayOrder)
            }
            issue.name = ac.textFields![0].text
            if !ac.textFields![1].text!.isEmpty {
                issue.fromDate = self.df.date(from: ac.textFields![1].text!)
            }
            if !ac.textFields![2].text!.isEmpty {
                issue.toDate = self.df.date(from: ac.textFields![2].text!)
            }
            self.pet?.addToHadHealthIssue(issue)
            self.dataSource.issues.append(issue)
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
            self.descriptionTextField = txt
            self.descriptionTextField?.placeholder = "Описание случая"
        }
        ac.addTextField { (txt) in
            self.fromDateTextField = txt
            self.fromDateTextField?.placeholder = "с: (дата)"
            self.fromDateTextField?.inputView = self.fromDatePicker
            self.fromDateTextField?.inputAccessoryView = self.toolbar
        }
        ac.addTextField { (txt) in
            self.toDateTextField = txt
            self.toDateTextField?.placeholder = " по: (дата)"
            self.toDateTextField?.inputView = self.toDatePicker
            self.toDateTextField?.inputAccessoryView = self.toolbar
        }
        NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: ac.textFields?[0], queue: OperationQueue.main) { (notif) in
            let tf = ac.textFields?[0]
            okAction.isEnabled = !tf!.text!.isEmpty
        }
        
        
        ac.addAction(okAction)
        ac.addAction(cancelAction)
        self.present(ac, animated: true, completion: nil)
    }
    
    @objc func doneAction(_ sender: Any) {
        if fromDateTextField!.isFirstResponder {
            fromDateTextField?.text = df.string(from: fromDatePicker.date)
            toDatePicker.minimumDate = fromDatePicker.date
            fromDateTextField?.resignFirstResponder()
        } else if toDateTextField!.isFirstResponder {
            toDateTextField?.text = df.string(from: toDatePicker.date)
            fromDatePicker.maximumDate = toDatePicker.date
            toDateTextField?.resignFirstResponder()
        }
    }
    
    

}
