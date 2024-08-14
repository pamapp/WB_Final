//
//  ContentView.swift
//  WB_Final
//
//  Created by Alina Potapova on 10.08.2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var fetchedBreeds: DogBreedService = .init()
    @StateObject private var breedMessageManager: BreedMessageManager = .init()

    var body: some View {
        PersonalChatScreen()
            .environmentObject(fetchedBreeds)            
            .environmentObject(breedMessageManager)
    }
}

#Preview {
    ContentView()
}
