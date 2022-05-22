//
//  SearchViewController.swift
//  ToDoList
//
//  Created by Matúš Mištrik on 29/04/2022.
//

import UIKit

/// Trieda ma na starosti spravu UI elementov obrazovky SearchViewController.storyboard.
class SearchViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    private let searchController = UISearchController(searchResultsController: nil)
    
    
    //MARK: - Variables
    private var filteredItems: [SearchModel] = []
    
    private var items: [SearchModel] = []
    
    private var searchText: String?
    
    
    //MARK: - Lifecycles
    /// Tato metoda je volana po tom, co sa naloaduje View z ViewControllera. V tejto metode sa nastavi tableView a searchBar.
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.register(
            UINib(
                nibName: TodoTaskTableViewCell.classString,
                bundle: nil),
            forCellReuseIdentifier: TodoTaskTableViewCell.classString)
        setupSearchBar()
    }
    
    /// Tato metoda je volana po tom, co sa objavi View z ViewControllera. Metoda updatne zoznam vyhladavanych taskov
    override func viewDidAppear(_ animated: Bool) {
        updateCurrentTasks()
    }
}


// MARK: Functions
extension SearchViewController {
    /// Metoda vyfiltuje z aktualnych taskov take tasky, ktore maju nazov rovnaky, ako hodnota parametra metody. Vyfiltrovane tasky ulozi do atributu filteredItems.
    /// - Parameter searchText: <#searchText description#>
    private func filterContentForSearchText(_ searchText: String) {
        filteredItems = items.filter({ item in
            return item.task.name.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }
}


//MARK: - Data source
extension SearchViewController: UITableViewDataSource {
    
    /// Metoda vrati pocet riadkov.
    /// - Parameters:
    ///   - tableView: Objekt tableView, ktory ziada tuto informaciu.
    ///   - section: Index sekcie.
    /// - Returns: pocet riadkov v danej sekcii.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredItems.count
    }
    
    
    /// Metoda si pyta od zdroja cellu, aby ju mohla dat na urcite miesto v tableView. V metode sa vytvori vytvori cella z TodoTaskTableCell, ktoru naplni hodnotami a nasledne ju vrati.
    /// - Parameters:
    ///   - tableView: Objekt tableView, ktory ziada tuto informaciu.
    ///   - indexPath: Index na lokalizovanie riadku v tableView.
    /// - Returns: Objekt, ktory dedi z UITableViewCell.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let taskCell = tableView.dequeueReusableCell(withIdentifier: TodoTaskTableViewCell.classString, for: indexPath) as? TodoTaskTableViewCell
        else {
            return UITableViewCell()
        }
    
        taskCell.setupCell(with: filteredItems[indexPath.row].task, at: (filteredItems[indexPath.row].section, filteredItems[indexPath.row].row))
        taskCell.buttonDelegate = self
        return taskCell
    }
}


//MARK: - Search result updating
extension SearchViewController: UISearchResultsUpdating {
    
    /// Zdedena metoda z UISearchResultUpdating. Ziada objekt o aktualizovanie vysledkov hladania pre konkretny controller
    /// - Parameter searchController: Objekt UISearchController, ktory je pouzity ako search bar
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
        searchText = searchBar.text
    }
}


//MARK: - Private functions
extension SearchViewController {
    /// Vytvori seach bar
    private func setupSearchBar() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = NSLocalizedString("search_text", comment: "text inside search bar")
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    /// Aktualizuje aktualny zoznam taskov
    private func updateCurrentTasks() {
        items = []
        for (section, element) in TodoListManager.shared.listOfTasks.enumerated() {
            for (row, task) in element.tasks.enumerated() {
                items.append(SearchModel(section: section, row: row, task: task))
            }
        }
        
        if let searchText = self.searchText {
            filterContentForSearchText(searchText)
        }
        
        tableView.reloadData()
    }
}

//MARK: - Cell Delegate
extension SearchViewController: TodoTaskTableViewCellDelegate {
    /// Metoda delegata TodoTaskTableViewCellDelegate. Hovori, ze modify button v Celle bol stlaceny. Metoda pushne novy screen EditTaskViewController
    /// - Parameter position: Pozicia celly v zozname
    func didModifyButtonPressed(cellForRowAt position: taskPosition) {
        definesPresentationContext = false
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
             let index = filteredItems.firstIndex { item in
                item.section == position.section && item.row == position.row
                }
            filteredItems[index!].task.completed = !filteredItems[index!].task.completed
            updateCurrentTasks()
        }
    }
}


//MARK: - Transition Delegate
extension SearchViewController: UIViewControllerTransitioningDelegate {
    
    /// Metoda delegata UIViewControllerTransitioningDelegate. Metoda monitoruje prechody medzi obrazovkami.
    /// - Parameter dismissed: Objekt viewControllera, ktory sa ma zahodit
    /// - Returns: Objekt animacie, ktory sa pouzije, ked sa obrazovka zahodi
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        updateCurrentTasks()
        return nil
    }
}
