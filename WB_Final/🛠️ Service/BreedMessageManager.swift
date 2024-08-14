//
//  BreedMessageManager.swift
//  WB_Final
//
//  Created by Alina Potapova on 14.08.2024.
//

import SwiftUI
import DogsAPI
import ExyteChat

final class BreedMessageManager: ObservableObject {
    @Published var breedMessages: [BreedMessage] = []
    @Published var messages: [Message] = []
    @Published var command: Commands = .all(false)
    
    private let replyMessage = Message(id: UUID().uuidString, user: User(id: "2", name: "Ответчик", avatarURL: nil, isCurrentUser: false), status: .none, text: "😢 Пусто")
    
    func updateBreedMessages(from breeds: [Breed]) {
        self.breedMessages = breeds.map { BreedMessage(breed: $0) }
    }
    
    func getMessages() -> [Message] {
        breedMessages.map { $0.message }
    }
    
    func getFavoriteBreedMessages(favoriteImageIds: [String]) -> [BreedMessage] {
        breedMessages.filter { favoriteImageIds.contains($0.breed.referenceImageId ?? "") }
    }
    
    func getImageId(for messageId: String) -> String? {
        breedMessages.first(where: { $0.message.id == messageId })?.breed.referenceImageId
    }
    
    func updateMessages(fetchedBreeds: DogBreedService) {
        switch command {
        case .all(let ascending):
            messages = ascending ? getMessages().reversed() : getMessages()
            
        case .favorite:
            let favoriteBreedMessages = getFavoriteBreedMessages(favoriteImageIds: fetchedBreeds.getFavoriteImageIds())
            messages = !favoriteBreedMessages.isEmpty ? favoriteBreedMessages.map { $0.message } : [ replyMessage ]

        case .heaviest(let ascending):
            let sortedBreedMessages = breedMessages.sorted(by: .weight, ascending: ascending)
            messages = sortedBreedMessages.map { $0.message }
            
        case .tallest(let ascending):
            let sortedBreedMessages = breedMessages.sorted(by: .height, ascending: ascending)
            messages = sortedBreedMessages.map { $0.message }

        case .lifeSpan(let ascending):
            let sortedBreedMessages = breedMessages.sorted(by: .lifeSpan, ascending: ascending)
            messages = sortedBreedMessages.map { $0.message }
            
        case .search(let searchString):
            let filteredMessages = getMessages().filtered(by: searchString)
            messages = !filteredMessages.isEmpty ? filteredMessages : [ replyMessage ]
        }
    }
    
    func toggleLikeStatus(imageId: String, fetchedBreeds: DogBreedService) async {
        if fetchedBreeds.isBreedFavorite(imageId) {
            _ = await removeFavorite(imageId, fetchedBreeds: fetchedBreeds)
        } else {
            _ = await addFavorite(imageId, fetchedBreeds: fetchedBreeds)
        }
    }
    
    private func addFavorite(_ imageId: String, fetchedBreeds: DogBreedService) async -> Bool {
        return await fetchedBreeds.addFavorite(imageId: imageId)
    }

    private func removeFavorite(_ imageId: String, fetchedBreeds: DogBreedService) async -> Bool {
        guard let favorite = fetchedBreeds.favoriteBreeds.first(where: { $0.imageId == imageId }) else {
            return false
        }
        
        return await fetchedBreeds.removeFavorite(id: favorite.id)
    }
}
