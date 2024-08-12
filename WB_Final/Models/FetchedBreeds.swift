//
//  Breeds.swift
//  DogsApp
//
//  Created by Alina Potapova on 31.07.2024.
//

import Foundation
import DogsAPI
import ExyteChat

let apiKey = "live_Bh5aaflQcIYKDlHRRQE07rDeRdWyiauGYTYIq4g6ey6RSntWS69eJtqg5RZCG3cY"
let subId = "user"
let user = User(id: "1", name: "Dogs", avatarURL: nil, isCurrentUser: false)

class FetchedBreeds: ObservableObject {
    @Published var breedMessages: [BreedMessage] = [] { didSet { isLoading = false } }
    @Published var favoriteBreeds: [Like] = []
    @Published var isLoading: Bool = true

    func loadBreeds(completion: @escaping (_ data: [BreedMessage]?, _ error: Error?) -> Void) {
        isLoading = true
        DogsAPI.getBreeds { data, error in
            defer { self.isLoading = false }
            if let error = error {
                print("Error fetching breeds: \(error)")
                completion(nil, error)
            }
            let breedMessages = data?.map { BreedMessage(breed: $0) } ?? []
            self.breedMessages = breedMessages
            completion(breedMessages, nil)
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
    
    func addFavorite(imageId: String, subId: String) async -> Bool {
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

extension FetchedBreeds {
    func isBreedFavorite(_ message: Message) -> Bool {
        let breedMessage = breedMessages.first(where: { $0.message.id == message.id })
        let imageId = breedMessage?.breed.referenceImageId

        return favoriteBreeds.contains { $0.imageId == imageId }
    }
    
    func isBreedFavorited(_ imageId: String?) -> Bool {
         favoriteBreeds.contains { $0.imageId == imageId }
    }
    
    func maximumValue(for characteristic: Characteristics) -> Int {
        switch characteristic {
        case .weight: 
            breedMessages.compactMap { $0.breed.weight?.metric?.criteriaToInt() }.max() ?? 0
        case .height: 
            breedMessages.compactMap { $0.breed.height?.metric?.criteriaToInt() }.max() ?? 0
        case .lifeSpan: 
            breedMessages.compactMap { $0.breed.lifeSpan?.criteriaToInt() }.max() ?? 0
        default: 
            0
        }
    }
}

extension Breed {
    func progress(for characteristic: Characteristics, maxValue: Int) -> Double {
        let currentValue: Int
        
        switch characteristic {
        case .weight:
            currentValue = weight?.metric?.criteriaToInt() ?? 0
        case .height:
            currentValue = height?.metric?.criteriaToInt() ?? 0
        case .lifeSpan:
            currentValue = lifeSpan?.criteriaToInt() ?? 0
        default:
            currentValue = 0
        }
        
        return maxValue > 0 ? Double(currentValue) / Double(maxValue) : 0
    }
}

extension Breed {
    func toMessage() -> Message {
        Message(id: UUID().uuidString,
                user: user,
                createdAt: Date(),
                text: name,
                attachments: [
                    Attachment(id: String(id),
                               url: URL(string: image ?? "")!,
                               type: .image)
                ]
        )
    }
}

struct BreedMessage: Identifiable {
    let id: UUID
    let message: Message
    let breed: Breed
    
    init(breed: Breed) {
        self.id = UUID()
        self.breed = breed
        self.message = breed.toMessage()
    }
}

extension Breed: Identifiable { }
extension Like: Identifiable { }
