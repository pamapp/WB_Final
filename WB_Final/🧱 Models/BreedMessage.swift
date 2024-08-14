//
//  BreedMessage.swift
//  WB_Final
//
//  Created by Alina Potapova on 13.08.2024.
//

import SwiftUI
import DogsAPI
import ExyteChat

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

final class BreedMessageManager: ObservableObject {
    @Published var breedMessages: [BreedMessage] = []
    
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
}
