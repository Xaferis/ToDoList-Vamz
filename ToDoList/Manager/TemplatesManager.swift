//
//  TemplatesManager.swift
//  ToDoList
//
//  Created by Matúš Mištrik on 18/05/2022.
//

import Foundation


typealias TemplatesCompletionHandler = () -> Void



/// Tato trieda je singleton. Ma na starosti spravu vytvorenych sablon, t.j. ich modifikaciu, pridavanie, mazanie, ukladanie do pamati ...
class TemplatesManager {
    
    
    //MARK: - Variables
    /// Vrati instanciu triedy
    static let shared = TemplatesManager()
    
    /// Zoznam aktualne ulozenych sablon. Pri zmene zoznamu sa vzdy ulozi stav zoznamu do pamate.
    var templates: [TemplateItem] = [] {
        didSet {
            saveTemplates()
        }
    }
    
    private let UDkey = "favourite_list"
    
    
    //MARK: - Template Methods
    /// Funkcia ulozi zoznam sablon do pamate.
    private func saveTemplates() {
        if let encodedData = try? JSONEncoder().encode(templates) {
            UserDefaults.standard.set(encodedData, forKey: UDkey)
        }
    }
    
    /// Funkcia nacita z pamate ulozene sablony do atributu `templates`.
    /// - Parameter completion: Closure bez parametrov a navratovej hodnoty, predsatuvje prikazy, ktore sa maju este dodatocne uskutocnit.
    func loadTemplates(completion: TemplatesCompletionHandler) {
        guard
            let decodedData = UserDefaults.standard.data(forKey: UDkey),
            let savedTemplates = try? JSONDecoder().decode([TemplateItem].self, from: decodedData)
        else { return }
        
        self.templates = savedTemplates
        completion()
    }
    
    /// Funkcia prida sablonu prijatu v parametri do zoznamu sablon.  Nasledne sa zoznam ulozi do pamate.
    /// - Parameters:
    ///   - item: Nova sablona, ktora sa ma pridat.
    ///   - completion: Closure bez parametrov a navratovej hodnoty, predsatuvje prikazy, ktore sa maju este dodatocne uskutocnit.
    func addTemplate(item: TemplateItem, completion: TemplatesCompletionHandler) {
        templates.append(item)
        completion()
    }
    
    /// Funkcia upravenu sablonu zaradi na miesto stareho. Novy stav zoznamu nasledne ulozi do pamate.
    /// - Parameters:
    ///   - newItem: Zmenena sablona.
    ///   - index: Index menenej sablony.
    ///   - completion: Closure bez parametrov a navratovej hodnoty, predsatuvje prikazy, ktore sa maju este dodatocne uskutocnit.
    func editTemplate(newItem: TemplateItem, at index: Int, completion: TemplatesCompletionHandler) {
        templates[index] = newItem
        saveTemplates()
        completion()
    }
    
    /// Funkcia vymaze zo zoznamu sablonu na pozicii zadanej v parametri. Nasledne sa novy stav zoznamu ulozi do pamate.
    /// - Parameters:
    ///   - index: Index mazanej sablony
    ///   - completion: Closure bez parametrov a navratovej hodnoty, predsatuvje prikazy, ktore sa maju este dodatocne uskutocnit.
    func deleteTemplate(at index: Int, completion: TemplatesCompletionHandler) {
        templates.remove(at: index)
        completion()
    }
}
