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
        if let navigationController = storyboard.instantiateInitialViewController() as? UINavigationController,
           let addViewController = navigationController.topViewController as? AddItemViewController {
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
        tableView.delegate = self
        tableView.register(
            UINib(
                nibName: TodoTaskTableViewCell.classString,
                bundle: nil),
            forCellReuseIdentifier: TodoTaskTableViewCell.classString)
        print(NSLocalizedString("new_task_edit", comment: "default name, if the name box wasn't filled"));
    }
    
    override func viewDidAppear(_ animated: Bool) {
        TodoListManager.shared.loadTasks {
            refreshTableView()
        }
    }
}

//MARK: - Data source

extension TodolistMainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 3
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let taskCell = tableView.dequeueReusableCell(withIdentifier: TodoTaskTableViewCell.classString,
                                                           for: indexPath) as? TodoTaskTableViewCell
        else {
            return UITableViewCell()
        }
        
        taskCell.setupCell(with: items[indexPath.row], at: indexPath.row)
        taskCell.buttonDelegate = self
        return taskCell
    }
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return "\(section+5).4.2022"
//    }
}


//MARK: - Delegate

extension TodolistMainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            TodoListManager.shared.deleteTask(at: indexPath.row) {
                items.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .fade)
                self.tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return TodoTaskTableViewCell.heightOfCell
    }
}


//MARK: - Transition Delegate

extension TodolistMainViewController: UIViewControllerTransitioningDelegate {

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        //print("Koniec popup controlleru")
        TodoListManager.shared.loadTasks {
            refreshTableView()
        }
        return nil
    }
}


//MARK: - Cell Delegate

extension TodolistMainViewController: TodoTaskTableViewCellDelegate {
    func didModifyButtonPressed(cellForRowAt index: Int) {
        //print(index)
        let storyboard = UIStoryboard(name: "EditItemViewController", bundle: nil)
        if let viewController = storyboard.instantiateViewController(withIdentifier: "EditItemViewController") as? EditItemViewController {
            viewController.taskIndex = index
            navigationController?.pushViewController(viewController, animated: true)
        }
        
//        if let navigationController = storyboard.instantiateInitialViewController() {
//            present(navigationController, animated: true)
//            navigationController.transitioningDelegate = self
//        }
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "EditItemViewController1")
//       // vc.taskIndex = index
        
    }
    
    func didCheckButtonPressed(cellForRowAt index: Int) {
        TodoListManager.shared.changeStateOfTask(at: index) {
            refreshTableView()
        }
    }
}

// MARK: - Refresh table view
extension TodolistMainViewController {
    func refreshTableView() {
        self.items = TodoListManager.shared.getTasks()
        self.tableView.reloadData()
    }
}
