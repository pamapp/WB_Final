//
//  Array+Extensions.swift
//  DogsApp
//
//  Created by Alina Potapova on 04.08.2024.
//

import Foundation
import DogsAPI

extension Array where Element == Breed {
    func filtered(by searchText: String) -> [Breed] {
        if searchText.isEmpty {
            return self
        } else {
            return self.filter {
                $0.name.lowercased().contains(searchText.lowercased())
            }
        }
    }
    
    func sorted(by sortBy: SortBy) -> [Breed] {
        switch sortBy {
        case .name:
            return self.sorted { $0.name < $1.name }
        case .height:
            return self.sorted { sortBy.criteriaToInt($0.height?.metric) < sortBy.criteriaToInt($1.height?.metric) }
        case .weight:
            return self.sorted { sortBy.criteriaToInt($0.weight?.metric) < sortBy.criteriaToInt($1.weight?.metric) }
        case .lifespan:
            return self.sorted { sortBy.criteriaToInt($0.lifeSpan) < sortBy.criteriaToInt($1.lifeSpan) }
        }
    }
    
    func favoriteBreeds(from likes: [Like]) -> [Breed] {
        let favoriteImageIds = Set(likes.map { $0.imageId })
        return self.filter { favoriteImageIds.contains($0.referenceImageId ?? "") }
    }
}
