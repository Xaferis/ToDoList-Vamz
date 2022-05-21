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
    
    
    //MARK: - Variables
    private var items: [TemplateItem] = []
    
    var completionHandler: ((TemplateItem) -> Void)?
    
    
    //MARK: - Lifecycles
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
extension TemplatePickViewController: UITableViewDataSource {
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
        self.items = TemplatesManager.shared.templates
        self.tableView.reloadData()
    }
}
