//
//  SearchViewController.swift
//  ToDoList
//
//  Created by Matúš Mištrik on 29/04/2022.
//

import UIKit

class SearchViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    private let searchController = UISearchController(searchResultsController: nil)
    
    
    //MARK: - Variables
    private var filteredItems: [SearchModel] = []
    
    private var items: [SearchModel] = []
    
    
    //MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.register(
            UINib(
                nibName: TodoTaskTableViewCell.classString,
                bundle: nil),
            forCellReuseIdentifier: TodoTaskTableViewCell.classString)
        setupSearchBar()
        print("Search")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateCurrentTasks()
        print("tu to blbne")
    }
}


// MARK: Functions
extension SearchViewController {
    func filterContentForSearchText(_ searchText: String) {
        filteredItems = items.filter({ item in
            return item.task.name.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }
}


//MARK: - Data source
extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredItems.count
    }
    
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
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
}


//MARK: - Private functions
extension SearchViewController {
    private func setupSearchBar() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = NSLocalizedString("search_text", comment: "text inside search bar")
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private func updateCurrentTasks() {
        items = []
        for (section, element) in TodoListManager.shared.listOfTasks.enumerated() {
            for (row, task) in element.tasks.enumerated() {
                items.append(SearchModel(section: section, row: row, task: task))
            }
        }
    }
}

//MARK: - Cell Delegate
extension SearchViewController: TodoTaskTableViewCellDelegate {
    func didModifyButtonPressed(cellForRowAt position: taskPosition) {
        //print(index)
        let storyboard = UIStoryboard(name: "EditTaskViewController", bundle: nil)
        if let viewController = storyboard.instantiateViewController(withIdentifier: "EditTaskViewController") as? EditTaskViewController {
            viewController.taskIndex = position
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    func didCheckButtonPressed(cellForRowAt position: taskPosition) {
        TodoListManager.shared.changeStateOfTask(at: position) {
             let index = filteredItems.firstIndex { item in
                item.section == position.section && item.row == position.row
                }
            filteredItems[index!].task.completed = !filteredItems[index!].task.completed
            updateCurrentTasks()
            tableView.reloadData()
        }
    }
}
