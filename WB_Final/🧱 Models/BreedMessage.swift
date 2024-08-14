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
        self.message = breed.message
    }
}
