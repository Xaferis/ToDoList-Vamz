//
//  FavouritesManager.swift
//  ToDoList
//
//  Created by Matúš Mištrik on 18/05/2022.
//

import Foundation


typealias FavouritesCompletionHandler = () -> Void

class FavouritesManager {
    
    
    //MARK: - Variables
    static let shared = FavouritesManager()
    
    var favourites: [FavouriteItem] = [] {
        didSet {
            saveFavourites()
        }
    }
    
    private let UDkey = "favourite_list"
    
    
    //MARK: - Favourite Methods
    private func saveFavourites() {
        if let encodedData = try? JSONEncoder().encode(favourites) {
            UserDefaults.standard.set(encodedData, forKey: UDkey)
        }
    }
    
    func loadFavourites(completion: FavouritesCompletionHandler) {
        guard
            let decodedData = UserDefaults.standard.data(forKey: UDkey),
            let savedFavourites = try? JSONDecoder().decode([FavouriteItem].self, from: decodedData)
        else { return }
        
        self.favourites = savedFavourites
        completion()
    }
    
    func addFavourite(item: FavouriteItem, completion: FavouritesCompletionHandler) {
        favourites.append(item)
        completion()
    }
    
    func editFavourite(newItem: FavouriteItem, at index: Int, completion: FavouritesCompletionHandler) {
        favourites[index] = newItem
        saveFavourites()
        completion()
    }
    
    func deleteFavourite(at index: Int, completion: FavouritesCompletionHandler) {
        favourites.remove(at: index)
        completion()
    }
    
    func swapFavourites(from oldIndex: Int, to newIndex: Int, completion: FavouritesCompletionHandler) {
        favourites.swapAt(oldIndex, newIndex)
    }
}
