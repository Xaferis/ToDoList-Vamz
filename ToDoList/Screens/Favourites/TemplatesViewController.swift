//
//  TemplatesViewController.swift
//  ToDoList
//
//  Created by Matúš Mištrik on 29/04/2022.
//

import UIKit

class TemplatesViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    
    //MARK: - Variables
    private var items: [TemplateItem] = []
    private let hapticFeedback = UIImpactFeedbackGenerator()
    
    
    //MARK: - Actions
    @IBAction func addButton(_ sender: Any) {
        hapticFeedback.impactOccurred()
        let storyboard = UIStoryboard(name: "AddTemplateViewController", bundle: nil)
        if let navigationController = storyboard.instantiateInitialViewController() as? UINavigationController {
            present(navigationController, animated: true)
            navigationController.transitioningDelegate = self
        }
    }
    
    
    //MARK: - Lifecycles
    override func viewDidAppear(_ animated: Bool) {
        refreshTableView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(
            UINib(
                nibName: TemplatesTableViewCell.classString,
                bundle: nil),
            forCellReuseIdentifier: TemplatesTableViewCell.classString)
        
        TemplatesManager.shared.loadTemplates {
            refreshTableView()
        }
    }
}


//MARK: - Data source
extension TemplatesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TemplatesTableViewCell.classString, for: indexPath) as? TemplatesTableViewCell
        else {
            return UITableViewCell()
        }
        
        cell.setupCell(with: items[indexPath.row])
        return cell;
    }
}


//MARK: - Transition Delegate
extension TemplatesViewController: UIViewControllerTransitioningDelegate {

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        refreshTableView()
        return nil
    }
}


//MARK: - Delegate
extension TemplatesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        hapticFeedback.impactOccurred()
        let storyboard = UIStoryboard(name: "EditTemplateViewController", bundle: nil)
        if let navigationController = storyboard.instantiateInitialViewController() as? UINavigationController,
           let editViewController = navigationController.topViewController as? EditTemplateViewController {
            present(navigationController, animated: true)
            editViewController.position = indexPath.row
            navigationController.transitioningDelegate = self
        }
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            TemplatesManager.shared.deleteTemplate(at: indexPath.row) {
                self.items.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .fade)
                self.tableView.reloadData()
            }
        }
    }
}


//MARK: - Private functions
extension TemplatesViewController {
    private func refreshTableView() {
        self.items = TemplatesManager.shared.templates
        self.tableView.reloadData()
    }
}
