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
        let storyboard = UIStoryboard(name: "AddTaskViewController", bundle: nil)
        if let navigationController = storyboard.instantiateInitialViewController() as? UINavigationController {
            present(navigationController, animated: true)
            navigationController.transitioningDelegate = self
        }
    }
    
    //MARK: - Variables
    
    private var items: [DayTask] = []
    
    private let dateFormatter = DateFormatter()
    
    
    //MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.dateFormat = "dd.MM.YYYY"
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(
            UINib(
                nibName: TodoTaskTableViewCell.classString,
                bundle: nil),
            forCellReuseIdentifier: TodoTaskTableViewCell.classString)
        
        TodoListManager.shared.loadTasks {
            refreshTableView()
        }
        }
    
    override func viewDidAppear(_ animated: Bool) {
        refreshTableView()
    }
}

//MARK: - Data source

extension TodolistMainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section].tasks.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let taskCell = tableView.dequeueReusableCell(withIdentifier: TodoTaskTableViewCell.classString,
                                                           for: indexPath) as? TodoTaskTableViewCell
        else {
            return UITableViewCell()
        }
        
        taskCell.setupCell(with: items[indexPath.section].tasks[indexPath.row], at: (indexPath.section, indexPath.row))
        taskCell.buttonDelegate = self
        return taskCell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dateFormatter.string(from: items[section].date) ==
                dateFormatter.string(from: TodoListManager.completedDate!) ? NSLocalizedString("completed", comment: "completed tasks") : dateFormatter.string(from: items[section].date)
    }
}


//MARK: - Delegate

extension TodolistMainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            TodoListManager.shared.deleteTask(at: (indexPath.section, indexPath.row)) {
                self.items[indexPath.section].tasks.remove(at: indexPath.row)
                if self.items[indexPath.section].tasks.isEmpty {
                    self.items.remove(at: indexPath.section)
                    self.tableView.deleteSections([indexPath.section], with: .fade)
                } else {
                    self.tableView.deleteRows(at: [indexPath], with: .fade)
                }
                self.tableView.reloadData()
            }
        }
    }
}


//MARK: - Transition Delegate

extension TodolistMainViewController: UIViewControllerTransitioningDelegate {

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        refreshTableView()
        return nil
    }
}


//MARK: - Cell Delegate
extension TodolistMainViewController: TodoTaskTableViewCellDelegate {
    func didModifyButtonPressed(cellForRowAt position: taskPosition) {
        let storyboard = UIStoryboard(name: "EditTaskViewController", bundle: nil)
        if let navigationController = storyboard.instantiateInitialViewController() as? UINavigationController,
           let editViewController = navigationController.topViewController as? EditTaskViewController {
            present(navigationController, animated: true)
            editViewController.taskIndex = position
            navigationController.transitioningDelegate = self
        }
    }
    
    func didCheckButtonPressed(cellForRowAt position: taskPosition) {
        TodoListManager.shared.changeStateOfTask(at: position) {
            refreshTableView()
        }
    }
}

// MARK: - Refresh table view
extension TodolistMainViewController {
    private func refreshTableView() {
        self.items = TodoListManager.shared.listOfTasks
        self.tableView.reloadData()
    }
}
