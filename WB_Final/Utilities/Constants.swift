//
//  Constants.swift
//  WB_Final
//
//  Created by Alina Potapova on 10.08.2024.
//

import SwiftUI

enum UI {
    enum Strings {
        static let dogBreeds: String = "Dog Breeds"
        static let all: String = "All"
        static let favorites: String = "Favorites"
        static let sortBy: String = "Sort by"

        static let breeds: String = "Breeds"
        static let basicCharacteristics: String = "Basic Characteristics"
        static let temperament: String = "Temperament"
        static let weight: String = "Weight"
        static let height: String = "Height"
        static let lifeSpan: String = "Life span"
        static let breedGroup: String = "Breed group"
        static let bredFor: String = "Bred for"
        static let awesome: String = "Awesome"

        static var send: String { localizedString(for: .send) }
        static var sending: String { localizedString(for: .sending) }
        static var read: String { localizedString(for: .read) }
        static var error: String { localizedString(for: .error) }
        
        static func localizedString(for key: LocalizationKeys) -> String {
            return NSLocalizedString(key.rawValue, comment: key.rawValue)
        }
    }
    
    enum Icons {
        static let search: String = "search"
        static let plus: String = "plus"
        static let back: String = "chevron.left"
        static let mic: String = "mic"
        static let paperplane: String = "paperplane"
        static let lines: String = "lines"
        static let pauseAudio: String = "pauseAudio"
        static let playAudio: String = "playAudio"
        static let heart: String = "heart"
    }
}
