//
//  ImageLoadStatePublisher.swift
//  WB_Final
//
//  Created by Андрей on 12.08.2024.
//

import SwiftUI
import Combine

class ImageLoadStatePublisher: ObservableObject {
    @Published var loadState: ImageLoadState = .idle
    
    enum ImageLoadState {
        case idle
        case loading
        case loaded(UIImage)
        case failed(ImageLoadError)
    }
    
    enum ImageLoadError: Error {
        case invalidData
        case networkError(Error)
        case unknownError
    }
}
