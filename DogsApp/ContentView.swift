//
//  ContentView.swift
//  DogsApp
//
//  Created by Alina Potapova on 31.07.2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var router: Router = .init()
    @StateObject private var fetchedBreeds: FetchedBreeds = .init()

    var body: some View {
        NavigationStack(path: $router.path) {
            router.getPage(.list)
                .navigationDestination(for: Route.self) { page in
                    router.getPage(page)
                }
        }
        .environmentObject(router)
        .environmentObject(fetchedBreeds)
    }
}
