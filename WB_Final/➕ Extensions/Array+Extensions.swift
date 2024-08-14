//
//  Array+Extensions.swift
//  WB_Final
//
//  Created by Андрей on 14.08.2024.
//

import DogsAPI
import ExyteChat

extension Array where Element == Message {
    func filtered(by searchText: String) -> [Message] {
        if searchText.isEmpty {
            return self
        } else {
            return self.filter {
                $0.text.lowercased().contains(searchText.lowercased())
            }
        }
    }
}

extension Array where Element == BreedMessage {
    func sorted(by sortBy: Characteristics, ascending: Bool) -> [BreedMessage] {
        switch sortBy {
        case .weight:
            return self.sorted {
                let leftWeight = $0.breed.weight?.metric?.criteriaToInt ?? 0
                let rightWeight = $1.breed.weight?.metric?.criteriaToInt ?? 0
                return ascending ? leftWeight < rightWeight : leftWeight > rightWeight
            }
        case .height:
            return self.sorted {
                let leftHeight = $0.breed.height?.metric?.criteriaToInt ?? 0
                let rightHeight = $1.breed.height?.metric?.criteriaToInt ?? 0
                return ascending ? leftHeight < rightHeight : leftHeight > rightHeight
            }
        case .lifeSpan:
            return self.sorted {
                let leftLifeSpan = $0.breed.lifeSpan?.criteriaToInt ?? 0
                let rightLifeSpan = $1.breed.lifeSpan?.criteriaToInt ?? 0
                return ascending ? leftLifeSpan < rightLifeSpan : leftLifeSpan > rightLifeSpan
            }
        case .breedGroup:
            return self.sorted {
                let leftGroup = $0.breed.breedGroup ?? ""
                let rightGroup = $1.breed.breedGroup ?? ""
                return ascending ? leftGroup.localizedCompare(rightGroup) == .orderedAscending : leftGroup.localizedCompare(rightGroup) == .orderedDescending
            }
        case .bredFor:
            return self.sorted {
                let leftBredFor = $0.breed.bredFor ?? ""
                let rightBredFor = $1.breed.bredFor ?? ""
                return ascending ? leftBredFor.localizedCompare(rightBredFor) == .orderedAscending : leftBredFor.localizedCompare(rightBredFor) == .orderedDescending
            }
        }
    }
}
