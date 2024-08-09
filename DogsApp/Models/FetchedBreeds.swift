//
//  Breeds.swift
//  DogsApp
//
//  Created by Alina Potapova on 31.07.2024.
//

import Foundation
import DogsAPI

let apiKey = "live_Bh5aaflQcIYKDlHRRQE07rDeRdWyiauGYTYIq4g6ey6RSntWS69eJtqg5RZCG3cY"
let subId = "user"

class FetchedBreeds: ObservableObject {
    @Published var breeds: [Breed] = [] { didSet { isLoading = false } }
    @Published var favoriteBreeds: [Like] = []
    @Published var isLoading: Bool = true

    func loadBreeds(completion: @escaping (_ data: [Breed]?, _ error: Error?) -> Void) {
        isLoading = true
        BreedsAPI.getBreeds { data, error in
            defer { self.isLoading = false }
            if let error = error {
                print("Error fetching breeds: \(error)")
                completion(nil, error)
            }
            self.breeds = data ?? []
            completion(data, nil)
        }
    }
    
    func loadFavorites(completion: @escaping ([Like]?, Error?) -> Void) {
        BreedsAPI.getLikes(apiKey: apiKey, subId: subId) { data, error in
            if let error = error {
                print("Error fetching favorites: \(error)")
                completion(nil, error)
            }
            self.favoriteBreeds = data ?? []
            completion(data, nil)
        }
    }
    
    func addFavorite(imageId: String, subId: String) async -> Bool {
        await withCheckedContinuation { continuation in
            BreedsAPI.addFavourite(apiKey: apiKey, addFavouriteRequest: AddFavouriteRequest(imageId: imageId, subId: subId)) { data, error in
                if let error = error {
                    print("Error adding favorite: \(error)")
                    continuation.resume(returning: false)
                } else {
                    self.loadFavorites { _, _ in
                        continuation.resume(returning: data != nil)
                    }
                }
            }
        }
    }
    
    func removeFavorite(id: Int) async -> Bool {
        await withCheckedContinuation { continuation in
            BreedsAPI.removeFavourite(id: id, apiKey: apiKey) { data, error in
                if let error = error {
                    print("Error removing favorite: \(error)")
                    continuation.resume(returning: false)
                } else {
                    self.loadFavorites { _, _ in
                        continuation.resume(returning: data != nil)
                    }
                }
            }
        }
    }
}

extension Breed: Identifiable { }
extension Like: Identifiable { }
