//
//  TemplatePickViewController.swift
//  ToDoList
//
//  Created by Matúš Mištrik on 21/05/2022.
//

import UIKit

class TemplatePickViewController: UIViewController {

    
    //MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func cancel(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Variables
    private var items: [FavouriteItem] = []
    
    var completionHandler: ((FavouriteItem) -> Void)?
    
    
    //MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(
            UINib(
                nibName: FavouritesTableViewCell.classString,
                bundle: nil),
            forCellReuseIdentifier: FavouritesTableViewCell.classString)
        
        FavouritesManager.shared.loadFavourites {
            refreshTableView()
        }
    }
}


//MARK: - Data source
extension TemplatePickViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FavouritesTableViewCell.classString, for: indexPath) as? FavouritesTableViewCell
        else {
            return UITableViewCell()
        }
        
        cell.setupCell(with: items[indexPath.row])
        return cell;
    }
}


//MARK: - Delegate
extension TemplatePickViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        completionHandler?(items[indexPath.row])
        navigationController?.popViewController(animated: true)

    }
}


//MARK: - Private functions
extension TemplatePickViewController {
    private func refreshTableView() {
        self.items = FavouritesManager.shared.favourites
        self.tableView.reloadData()
    }
}
