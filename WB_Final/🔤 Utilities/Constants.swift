//
//  Constants.swift
//  WB_Final
//
//  Created by Alina Potapova on 10.08.2024.
//

import SwiftUI

enum UI {
    enum Strings {
        static var dogBreeds: String { localizedString(for: .dogBreeds) }
        static var all: String { localizedString(for: .all) }
        static var favorites: String { localizedString(for: .favorites) }
        static var sortBy: String { localizedString(for: .sortBy) }
        static var command: String { localizedString(for: .command) }
        static var abc: String { localizedString(for: .abc) }
        static var heaviest: String { localizedString(for: .heaviest) }
        static var lightest: String { localizedString(for: .lightest) }
        static var tallest: String { localizedString(for: .tallest) }
        static var smallest: String { localizedString(for: .smallest) }

        static var basicInfo: String { localizedString(for: .basicInfo) }
        static var temperament: String { localizedString(for: .temperament) }
        static var weight: String { localizedString(for: .weight) }
        static var height: String { localizedString(for: .height) }
        static var lifeSpan: String { localizedString(for: .lifeSpan) }
        static var breedGroup: String { localizedString(for: .breedGroup) }
        static var bredFor: String { localizedString(for: .bredFor) }
        static var awesome: String { localizedString(for: .awesome) }
        static var kg: String { localizedString(for: .kg) }
        static var cm: String { localizedString(for: .cm) }
 
        static var addFav: String { localizedString(for: .addFav) }
        static var removeFav: String { localizedString(for: .removeFav) }

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
        static let heartFill: String = "heart.fill"
        static let dog: String = "dog"
    }
}
//
//enum Logger {
//    static let errorFetchingBreeds: StaticString = "Error fetching breeds: %{public}@"
//    static let successFetchingBreeds: StaticString = "Successfully fetched breeds. Number of breeds: %d"
//    static let emptyResponseFetchingBreeds: StaticString = "Received empty response when fetching breeds."
//    static let errorFetchingFavorites: StaticString = "Error fetching favorites: %{public}@"
//    static let errorAddingFavorite: StaticString = "Error adding favorite: %{public}@"
//    static let errorRemovingFavorite: StaticString = "Error removing favorite: %{public}@"
//    static let errorFetchingData: StaticString = "Error fetching data: %{public}@"
//}
//
