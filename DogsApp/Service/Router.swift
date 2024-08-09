//
//  Router.swift
//  DogsApp
//
//  Created by Alina Potapova on 31.07.2024.
//

import SwiftUI
import DogsAPI

enum Route: Hashable {
    case list
    case detail(Breed)
}

final class Router: ObservableObject {
    @Published var path = NavigationPath()
    
    func push(_ page: Route) {
        path.append(page)
    }
    
    func goBack() {
        path.removeLast()
    }
    
    @ViewBuilder
    func getPage(_ page: Route) -> some View {
        switch page {
        case .list:
            BreedsScreen()
        case .detail(let breed):
            BreedDetailView(breed: breed)
        }
    }
}
