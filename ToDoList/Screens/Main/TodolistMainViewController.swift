//
//  ViewController.swift
//  ToDoList
//
//  Created by Matúš Mištrik on 07/04/2022.
//

import UIKit

/// Trieda ma na starosti spravu UI elementov obrazovky TodolistMainViewController.storyboard.
class TodolistMainViewController: UIViewController {
    
    //MARK: - Outlets

    @IBOutlet weak var tableView: UITableView!
    

    //MARK: - Actions
    /// Metoda reagujuca na slacenie tlacidla +. Vytvori novu obrazovku s pridavanim taskov, ktoru nasledne aj pushne.
    /// - Parameter sender: Objekt volajuci tuto funkciu.
    @IBAction func add(_ sender: Any) {
        hapticFeedback.impactOccurred()
        let storyboard = UIStoryboard(name: "AddTaskViewController", bundle: nil)
        if let navigationController = storyboard.instantiateInitialViewController() as? UINavigationController {
            present(navigationController, animated: true)
            navigationController.transitioningDelegate = self
        }
    }
    
    //MARK: - Variables
    
    private var items: [DayTask] = []
    private let dateFormatter = DateFormatter()
    private let hapticFeedback = UIImpactFeedbackGenerator()
    
    
    //MARK: - Lifecycles
    /// Tato metoda je volana po tom, co sa naloaduje View z ViewControllera. V tejto metode sa nastavi tableView a nacitaju sa tasky.
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
    
    /// Tato metoda je volana po tom, co sa objavi View z ViewControllera. Metoda obnovi stav tableView
    override func viewDidAppear(_ animated: Bool) {
        refreshTableView()
    }
}

//MARK: - Data source
extension TodolistMainViewController: UITableViewDataSource {
    /// Metoda vrati pocet riadkov.
    /// - Parameters:
    ///   - tableView: Objekt tableView, ktory ziada tuto informaciu.
    ///   - section: Index sekcie.
    /// - Returns: Pocet riadkov v danej sekcii.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section].tasks.count
    }
    
    /// Metoda vrati pocet sekcii
    /// - Parameter tableView: Objekt tableView, ktory ziada tuto informaciu.
    /// - Returns: Pocet sekcii.
    func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }
    
    /// Metoda si pyta od zdroja cellu, aby ju mohla dat na urcite miesto v tableView. V metode sa vytvori vytvori cella z TodoTaskTableViewCell, ktoru naplni hodnotami a nasledne ju vrati.
    /// - Parameters:
    ///   - tableView: Objekt tableView, ktory ziada tuto informaciu.
    ///   - indexPath: Index na lokalizovanie riadku v tableView.
    /// - Returns: Objekt, ktory dedi z UITableViewCell.
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
    
    /// Metoda nastavi header pre danu sekciu
    /// - Parameters:
    ///   - tableView: Objekt tableView, ktory ziada tuto informaciu.
    ///   - section: Index sekcie.
    /// - Returns: Nazov sekcie.
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dateFormatter.string(from: items[section].date) ==
                dateFormatter.string(from: TodoListManager.completedDate!) ? NSLocalizedString("completed", comment: "completed tasks") : dateFormatter.string(from: items[section].date)
    }
}


//MARK: - Delegate
extension TodolistMainViewController: UITableViewDelegate {
    /// Metoda delegata UITableViewDelegate. Tato metoda oznami delegatovi, ktora cella bola oznacena a nasledne na nej vykona pozadovanu akciu. Metoda nastavi mazanie celly (tasku) posunutim dolava
    /// - Parameters:
    ///   - tableView: Objekt tableView, ktory ziada tuto informaciu.
    ///   - editingStyle: Styl editovania.
    ///   - indexPath: Index na lokalizovanie riadku v tableView.
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
    /// Metoda delegata UIViewControllerTransitioningDelegate. Metoda monitoruje prechody medzi obrazovkami.
    /// - Parameter dismissed: Objekt viewControllera, ktory sa ma zahodit
    /// - Returns: Objekt animacie, ktory sa pouzije, ked sa obrazovka zahodi
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        refreshTableView()
        return nil
    }
}


//MARK: - Cell Delegate
extension TodolistMainViewController: TodoTaskTableViewCellDelegate {
    /// Metoda delegata TodoTaskTableViewCellDelegate. Hovori, ze modify button v Celle bol stlaceny. Metoda pushne novy screen EditTaskViewController
    /// - Parameter position: Pozicia celly v zozname
    func didModifyButtonPressed(cellForRowAt position: taskPosition) {
        let storyboard = UIStoryboard(name: "EditTaskViewController", bundle: nil)
        if let navigationController = storyboard.instantiateInitialViewController() as? UINavigationController,
           let editViewController = navigationController.topViewController as? EditTaskViewController {
            present(navigationController, animated: true)
            editViewController.position = position
            navigationController.transitioningDelegate = self
        }
    }
    
    ///  Metoda delegata TodoTaskTableViewCellDelegate. Hovori, ze check button v Celle bol stlaceny. Metoda zmeni stav splnenia danej celly.
    /// - Parameter position: Pozicia danej celly.
    func didCheckButtonPressed(cellForRowAt position: taskPosition) {
        TodoListManager.shared.changeStateOfTask(at: position) {
            refreshTableView()
        }
    }
}

// MARK: - Refresh table view
extension TodolistMainViewController {
    /// Aktualizuje tasky a znova nacita tableView
    private func refreshTableView() {
        self.items = TodoListManager.shared.listOfTasks
        self.tableView.reloadData()
    }
}
