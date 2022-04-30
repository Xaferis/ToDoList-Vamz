//
//  ViewController.swift
//  ToDoList
//
//  Created by Matúš Mištrik on 07/04/2022.
//

import UIKit

class TodolistMainViewController: UIViewController {
    
    //MARK: - Outlets

    @IBOutlet weak var tableView: UITableView!
    

    //MARK: - Actions
    
    @IBAction func add(_ sender: Any) {
        let storyboard = UIStoryboard(name: "AddItemViewController", bundle: nil)
        if let navigationController = storyboard.instantiateInitialViewController() {
            present(navigationController, animated: true)
            navigationController.transitioningDelegate = self
        }
    }
    
    //MARK: - Variables
    
    var items: [Task] = []
    
    
    //MARK: - Lifecycles

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.register(
            UINib(
                nibName: TodoTaskTableViewCell.classString,
                bundle: nil),
            forCellReuseIdentifier: TodoTaskTableViewCell.classString)
        print(items)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        TodoListManager.shared.loadTasks {
            self.items = TodoListManager.shared.tasks
            tableView.reloadData()
            
        }
    }
}

//MARK: - Data source

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


//MARK: - Transition Delegate

extension TodolistMainViewController: UIViewControllerTransitioningDelegate {

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        TodoListManager.shared.loadTasks {
            self.items = TodoListManager.shared.tasks
            tableView.reloadData()
        }
        return nil
    }
}
