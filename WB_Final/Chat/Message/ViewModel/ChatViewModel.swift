//
//  ChatViewModel.swift
//  WB_Final
//
//  Created by Alina Potapova on 05.08.2024.
//

import SwiftUI
import ExyteChat

final class ChatViewModel: ObservableObject {
    @Published var messages: [Message] = []

    func send(draft: DraftMessage) async {
        let newMessage = await Message.makeMessage(id: UUID().uuidString, user: User(id: "1", name: "Steve", avatarURL: nil, isCurrentUser: true), draft: draft)
        await MainActor.run {
            self.messages.append(newMessage)
        }
    }
}
