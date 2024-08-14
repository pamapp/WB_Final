//
//  Array+Extensions.swift
//  WB_Final
//
//  Created by Андрей on 14.08.2024.
//

import DogsAPI
import ExyteChat

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
}

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
