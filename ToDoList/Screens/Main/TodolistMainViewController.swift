//
//  ViewController.swift
//  ToDoList
//
//  Created by Matúš Mištrik on 07/04/2022.
//

import UIKit

class TodolistMainViewController: UIViewController {
    
    @IBAction func add(_ sender: Any) {
        let storyboard = UIStoryboard(name: "AddItemViewController", bundle: nil)
        if let navigationController = storyboard.instantiateInitialViewController() {
            present(navigationController, animated: true)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

