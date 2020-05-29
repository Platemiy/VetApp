//
//  DogAidViewController.swift
//  VetApp
//
//  Created by Artemiy Platonov on 28.05.2020.
//  Copyright © 2020 Artemiy Platonov. All rights reserved.
//

import UIKit

class DogAidViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    
    let solutions = [
        ["Отравление": "Отравление — одна из самых больших опасностей, которая может произойти как на улице, так и дома.\n\nСимптомы: сонливость, спутанность, потеря координации, рвота, слюноотделение, судороги, пена из рта\n\nВ этом случае мало что можно сделать без врача, поэтому сразу постарайтесь доставить собаку в ближайший веткабинет. Если вы гуляете в городе на улице, скорее всего клиника найдется в ближайшем дворе.\n\nПервую помощь нужно оказать немедленно:\n1) Вызвать рвоту. Влейте в собаку побольше воды или надавите на корень языка. Поить можно только в том случае, если собака находится в сознании. Если же питомец потерял сознание, поить категорически нельзя.\n2) Дать абсорбенты. Активированный уголь или энтеросгель. Уголь — 1 таблетка на 1 кг веса, развести в воде.\n\nПосле этого обязательно идите в ближайшею ветеринарную клинику. Заниматься самолечением противопоказано."], ["Открытая рана/порез": "Симптомы: открытая рана, кровотечение\n\nЖивотные дерутся на улице и могут пораниться об острый предмет. Обычные царапины заживают сами, вы можете их даже не заметить. Но если кровотечение сильное, попробуйте наложить жгут или приложить давящую повязку, а потом отправляйтесь к ветеринару.\n\nНебольшие раны и царапины нужно продезинфицировать. Подойдет обычная перекись водорода, она не причинит кошке или собаке боль.\n\nХорошо промойте рану. Если рана находится в нижней части лапы, лучше забинтовать, чтобы первое время туда не попадала грязь. Следите за тем, что питомец не разлизывал и не расчесывал рану, иначе она будет долго заживать."]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.dataSource = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let index = tableView.indexPathForSelectedRow {
                   self.tableView.deselectRow(at: index, animated: false)
               }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? DescriptionViewController {
            if let row = tableView.indexPathForSelectedRow?.row {
                dest.text = Array(solutions[row])[0].value
            }
        }
    }

    

}

extension DogAidViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return solutions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dogproblem", for: indexPath) as! SolutionDogCell
        let problem = Array(solutions[indexPath.row])[0].key
        cell.problem = problem
        return cell
    }
}
