//
//  TemplatesViewController.swift
//  ToDoList
//
//  Created by Matúš Mištrik on 29/04/2022.
//

import UIKit

/// Trieda ma na starosti spravu UI elementov obrazovky TemplatesViewController.storyboard.
class TemplatesViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    
    //MARK: - Variables
    private var items: [TemplateItem] = []
    private let hapticFeedback = UIImpactFeedbackGenerator()
    
    
    //MARK: - Actions
    /// Metoda reagujuca na slacenie tlacidla +. Vytvori novu obrazovku s pridavanim sablon, ktoru nasledne aj pushne.
    /// - Parameter sender: Objekt volajuci tuto funkciu.
    @IBAction func addButton(_ sender: Any) {
        hapticFeedback.impactOccurred()
        let storyboard = UIStoryboard(name: "AddTemplateViewController", bundle: nil)
        if let navigationController = storyboard.instantiateInitialViewController() as? UINavigationController {
            present(navigationController, animated: true)
            navigationController.transitioningDelegate = self
        }
    }
    
    
    //MARK: - Lifecycles
    /// Tato metoda je volana po tom, co sa objavi View z ViewControllera. Metoda obnovi stav tableView
    override func viewDidAppear(_ animated: Bool) {
        refreshTableView()
    }
    
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
extension TemplatesViewController: UITableViewDataSource {
    
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


//MARK: - Transition Delegate
extension TemplatesViewController: UIViewControllerTransitioningDelegate {

    /// Metoda delegata UIViewControllerTransitioningDelegate. Metoda monitoruje prechody medzi obrazovkami.
    /// - Parameter dismissed: Objekt viewControllera, ktory sa ma zahodit
    /// - Returns: Objekt animacie, ktory sa pouzije, ked sa obrazovka zahodi
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        refreshTableView()
        return nil
    }
}


//MARK: - Delegate
extension TemplatesViewController: UITableViewDelegate {
    
    
    /// Metoda delegata UITableViewDelegate. Tato metoda oznami delegatovi, ktora cella bola oznacena. Metoda pushne novu obrazovku a nastavi jej atributy.
    /// - Parameters:
    ///   - tableView: Objekt tableView, ktory ziada tuto informaciu.
    ///   - indexPath: Index na lokalizovanie riadku v tableView.
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
    
    /// Metoda delegata UITableViewDelegate. Tato metoda oznami delegatovi, ktora cella bola oznacena a nasledne na nej vykona pozadovanu akciu. Metoda nastavi mazanie celly (sablony) posunutim dolava
    /// - Parameters:
    ///   - tableView: Objekt tableView, ktory ziada tuto informaciu.
    ///   - editingStyle: Styl editovania.
    ///   - indexPath: Index na lokalizovanie riadku v tableView.
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
    
    /// Aktualizuje sablony a znova nacita tableView
    private func refreshTableView() {
        self.items = TemplatesManager.shared.templates
        self.tableView.reloadData()
    }
}
