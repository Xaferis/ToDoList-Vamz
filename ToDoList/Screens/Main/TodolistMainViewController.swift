//
//  ViewController.swift
//  ToDoList
//
//  Created by Matúš Mištrik on 07/04/2022.
//

import UIKit

class TodolistMainViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
//    var items: [Task] = [
//        Task(name: "name", description: "desc", date: Date(), completed: true),
//        Task(name: "name2", description: "desc2", date: Date(), completed: true)
//    ]
    var items: [Task] = []
    
    
    @IBAction func add(_ sender: Any) {
        let storyboard = UIStoryboard(name: "AddItemViewController", bundle: nil)
        if let navigationController = storyboard.instantiateInitialViewController() {
            present(navigationController, animated: true)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ViewDidLoad")
//        TodoListManager.shared.loadTasks {
//            tableView.reloadData()
//            self.items = TodoListManager.shared.tasks
//        }
        tableView.dataSource = self
        
        tableView.register(
            UINib(
                nibName: TodoTaskTableViewCell.classString,
                bundle: nil),
            forCellReuseIdentifier: TodoTaskTableViewCell.classString)
        
        print(items)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("ViewDidAppear")
        TodoListManager.shared.loadTasks {
            self.items = TodoListManager.shared.tasks
            tableView.reloadData()
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("ViewWillAppear")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        print("ViewDidDisappear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("viewwilldisappear")
    }
    
    override func viewDidLayoutSubviews() {
        print("pls")
    }
    
    override func viewWillLayoutSubviews() {
        print("aaaa")
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        print("hih")
    }
}

extension TodolistMainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let taskCell = tableView.dequeueReusableCell(withIdentifier: TodoTaskTableViewCell.classString,
                                                           for: indexPath) as? TodoTaskTableViewCell
        else {
            return UITableViewCell()
        }
        
        taskCell.setupCell(with: items[indexPath.row])
        return taskCell
    }
}

