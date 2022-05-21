//
//  TemplatesManager.swift
//  ToDoList
//
//  Created by Matúš Mištrik on 18/05/2022.
//

import Foundation


typealias TemplatesCompletionHandler = () -> Void

class TemplatesManager {
    
    
    //MARK: - Variables
    static let shared = TemplatesManager()
    
    var templates: [TemplateItem] = [] {
        didSet {
            saveTemplates()
        }
    }
    
    private let UDkey = "favourite_list"
    
    
    //MARK: - Template Methods
    private func saveTemplates() {
        if let encodedData = try? JSONEncoder().encode(templates) {
            UserDefaults.standard.set(encodedData, forKey: UDkey)
        }
    }
    
    func loadTemplates(completion: TemplatesCompletionHandler) {
        guard
            let decodedData = UserDefaults.standard.data(forKey: UDkey),
            let savedTemplates = try? JSONDecoder().decode([TemplateItem].self, from: decodedData)
        else { return }
        
        self.templates = savedTemplates
        completion()
    }
    
    func addTemplate(item: TemplateItem, completion: TemplatesCompletionHandler) {
        templates.append(item)
        completion()
    }
    
    func editTemplate(newItem: TemplateItem, at index: Int, completion: TemplatesCompletionHandler) {
        templates[index] = newItem
        saveTemplates()
        completion()
    }
    
    func deleteTemplate(at index: Int, completion: TemplatesCompletionHandler) {
        templates.remove(at: index)
        completion()
    }
}
