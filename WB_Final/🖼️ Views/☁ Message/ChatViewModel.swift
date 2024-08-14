//
//  ChatViewModel.swift
//  WB_Final
//
//  Created by Alina Potapova on 05.08.2024.
//

import SwiftUI
import ExyteChat

enum Command: Equatable {
    case all
    case favorite
    case search(String)
}

final class ChatViewModel: ObservableObject {
    @Published var messages: [Message] = []
    @Published var command: Command = .all
    
    func checkCommand(message: String) {
        switch message {
        case "Favorites", "Favorite", "Like", "Likes":
            self.command = .favorite
        case "All":
            self.command = .all
        default:
            self.command = .search(message)
        }
    }
}
