//
//  FavouritesViewController.swift
//  ToDoList
//
//  Created by Matúš Mištrik on 29/04/2022.
//

import UIKit

class FavouritesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var items: [FavouriteItem] = []
    
    
    @IBAction func addButton(_ sender: Any) {
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        FavouritesManager.shared.loadFavourites {
            refreshTableView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(
            UINib(
                nibName: FavouritesTableViewCell.classString,
                bundle: nil),
            forCellReuseIdentifier: FavouritesTableViewCell.classString)
    }

}

extension FavouritesViewController: UITableViewDataSource {
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

extension FavouritesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return FavouritesTableViewCell.heightOfCell
    }
}

extension FavouritesViewController {
    private func refreshTableView() {
        self.items = FavouritesManager.shared.getFavourites()
        self.tableView.reloadData()
    }
}
