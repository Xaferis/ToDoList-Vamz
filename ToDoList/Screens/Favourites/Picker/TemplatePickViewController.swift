//
//  TemplatePickViewController.swift
//  ToDoList
//
//  Created by Matúš Mištrik on 21/05/2022.
//

import UIKit

/// Trieda ma na starosti spravu UI elementov obrazovky TemplatePickViewController.storyboard.
class TemplatePickViewController: UIViewController {

    
    //MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    
    
    //MARK: - Variables
    private var items: [TemplateItem] = []
    private let hapticFeedback = UIImpactFeedbackGenerator()
    var completionHandler: ((TemplateItem) -> Void)?
    
    
    //MARK: - Lifecycles
    /// Tato metoda je volana po tom, co sa naloaduje View z ViewControllera. V tejto metode sa nastavi tableView a nacitaju sa sablony.
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
    
    /// Metoda vrati pocet riadkov.
    /// - Parameters:
    ///   - tableView: Objekt tableView, ktory ziada tuto informaciu.
    ///   - section: Index sekcie.
    /// - Returns: pocet riadkov v danej sekcii.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    /// Metoda si pyta od zdroja cellu, aby ju mohla dat na urcite miesto v tableView. V metode sa vytvori vytvori cella z TemplatesTableViewCell, ktoru naplni hodnotami a nasledne ju vrati.
    /// - Parameters:
    ///   - tableView: Objekt tableView, ktory ziada tuto informaciu.
    ///   - indexPath: Index na lokalizovanie riadku v tableView.
    /// - Returns: Objekt, ktory dedi z UITableViewCell.
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
    
    /// Metoda delegata UITableViewDelegate. Tato metoda oznami delegatovi, ktora cella bola oznacena. Vracia pomocou completionHandlera item, ktory bol vybraty a zahodi controller
    /// - Parameters:
    ///   - tableView: Objekt tableView, ktory ziada tuto informaciu.
    ///   - indexPath: Index na lokalizovanie riadku v tableView.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        hapticFeedback.impactOccurred()
        completionHandler?(items[indexPath.row])
        navigationController?.popViewController(animated: true)

    }
}


//MARK: - Private functions
extension TemplatePickViewController {
    
    /// Aktualizuje sablony a znova nacita tableView
    private func refreshTableView() {
        self.items = TemplatesManager.shared.templates
        self.tableView.reloadData()
    }
}
