//
//  ContentView.swift
//  WB_Final
//
//  Created by Alina Potapova on 10.08.2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var fetchedBreeds: FetchedBreeds = .init()

    var body: some View {
        PersonalChatView()
            .environmentObject(fetchedBreeds)
    }
}

#Preview {
    ContentView()
}
