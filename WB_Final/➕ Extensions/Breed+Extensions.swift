//
//  Breed+Extensions.swift
//  WB_Final
//
//  Created by Андрей on 14.08.2024.
//

import SwiftUI
import DogsAPI
import ExyteChat

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
                user: User(id: "1", name: "Dogs", avatarURL: nil, isCurrentUser: false),
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

extension Breed: Identifiable { }
extension Like: Identifiable { }
