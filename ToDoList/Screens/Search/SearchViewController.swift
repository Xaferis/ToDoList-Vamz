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
    private var filteredItems: [Task] = []
    
    private var items: [Task] = []
    
    private var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    
    private var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }


    //MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.register(
            UINib(
                nibName: TodoTaskTableViewCell.classString,
                bundle: nil),
            forCellReuseIdentifier: TodoTaskTableViewCell.classString)
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search tasks"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        TodoListManager.shared.loadTasks {
            items = TodoListManager.shared.listOfTasks.first?.tasks ?? []
        }
    }
}


// MARK: Functions
extension SearchViewController {
    func filterContentForSearchText(_ searchText: String) {
        filteredItems = items.filter({ item in
            return item.name.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }

}


//MARK: - Data source
extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredItems.count
        }
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let taskCell = tableView.dequeueReusableCell(withIdentifier: TodoTaskTableViewCell.classString, for: indexPath) as? TodoTaskTableViewCell
        else {
            return UITableViewCell()
        }
        
        if isFiltering {
            taskCell.setupCell(with: filteredItems[indexPath.row], at: (indexPath.section, indexPath.row))
        } else {
            taskCell.setupCell(with: items[indexPath.row], at: (indexPath.section, indexPath.row))
        }
        //taskCell.buttonDelegate = self
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
