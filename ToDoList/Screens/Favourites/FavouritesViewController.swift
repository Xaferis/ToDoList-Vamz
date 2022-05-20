//
//  FavouritesViewController.swift
//  ToDoList
//
//  Created by Matúš Mištrik on 29/04/2022.
//

import UIKit

class FavouritesViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    
    //MARK: - Variables
    private var items: [FavouriteItem] = []
    
    
    //MARK: - Actions
    @IBAction func addButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "AddFavouritesViewController", bundle: nil)
        if let navigationController = storyboard.instantiateInitialViewController() as? UINavigationController {
            present(navigationController, animated: true)
            navigationController.transitioningDelegate = self
        }
    }
    
    
    //MARK: - Lifecycles
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
            forCellReuseIdentifier: FavouritesTableViewCell.classString)    }

}


//MARK: - Data source
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


//MARK: - Transition Delegate
extension FavouritesViewController: UIViewControllerTransitioningDelegate {

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        FavouritesManager.shared.loadFavourites {
            refreshTableView()
        }
        return nil
    }
}


//MARK: - Delegate
extension FavouritesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "EditFavouritesViewController", bundle: nil)
        if let navigationController = storyboard.instantiateInitialViewController() as? UINavigationController,
           let editViewController = navigationController.topViewController as? EditFavouritesViewController {
            present(navigationController, animated: true)
            editViewController.position = indexPath.row
            navigationController.transitioningDelegate = self
        }
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            FavouritesManager.shared.deleteFavourite(at: indexPath.row) {
                self.items.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .fade)
                self.tableView.reloadData()
            }
        }
    }
}


//MARK: - Private functions
extension FavouritesViewController {
    private func refreshTableView() {
        self.items = FavouritesManager.shared.favourites
        self.tableView.reloadData()
    }
}
