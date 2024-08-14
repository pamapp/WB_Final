//
//  Breeds.swift
//  DogsApp
//
//  Created by Шамиль on 31.07.2024.
//

import Foundation
import DogsAPI
import ExyteChat
import os.log

class DogBreedService: ObservableObject {
    @Published var breeds: [Breed] = [] { didSet { isLoading = false } }
    @Published var favoriteBreeds: [Like] = []
    @Published var isLoading: Bool = true
    
    let apiKey = "live_Bh5aaflQcIYKDlHRRQE07rDeRdWyiauGYTYIq4g6ey6RSntWS69eJtqg5RZCG3cY"
    let subId = "user"
    
    func loadBreeds(completion: @escaping (_ data: [Breed]?, _ error: Error?) -> Void) {
        isLoading = true
        DogsAPI.getBreeds { data, error in
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
        DogsAPI.getLikes(apiKey: apiKey, subId: subId) { data, error in
            if let error = error {
                print("Error fetching favorites: \(error)")
                completion(nil, error)
            }
            self.favoriteBreeds = data ?? []
            completion(data, nil)
        }
    }
    
    func addFavorite(imageId: String) async -> Bool {
        await withCheckedContinuation { continuation in
            DogsAPI.addFavourite(apiKey: apiKey, addFavouriteRequest: AddFavouriteRequest(imageId: imageId, subId: subId)) { data, error in
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
            DogsAPI.removeFavourite(id: id, apiKey: apiKey) { data, error in
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

extension DogBreedService {
    func isBreedFavorite(_ imageId: String?) -> Bool {
        favoriteBreeds.contains { $0.imageId == imageId }
    }
    
    func getFavoriteImageIds() -> [String] {
        favoriteBreeds.compactMap { $0.imageId }
    }
    
    func maximumValue(for characteristic: Characteristics) -> Int {
        switch characteristic {
        case .weight:
            breeds.compactMap { $0.weight?.metric?.criteriaToInt() }.max() ?? 0
        case .height:
            breeds.compactMap { $0.height?.metric?.criteriaToInt() }.max() ?? 0
        case .lifeSpan:
            breeds.compactMap { $0.lifeSpan?.criteriaToInt() }.max() ?? 0
        default:
            0
        }
    }
}
