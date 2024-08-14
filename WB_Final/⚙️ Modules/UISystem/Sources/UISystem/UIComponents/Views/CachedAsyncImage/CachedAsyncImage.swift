//
//  CachedAsyncImage.swift
//  WB_Final
//
//  Created by Андрей & Alina Potapova on 10.08.2024.
//

import SwiftUI

public struct CachedAsyncImage: View {
    private var url: URL
    private var imageSize: (width: CGFloat?, height: CGFloat?)
    private var cornerRadius: CGFloat?

    @StateObject private var imageLoadStatePublisher = ImageLoadStatePublisher()
    @State private var task: Task<Void, Never>? = nil
    
    public init(url: URL, imageSize: (width: CGFloat?, height: CGFloat?), cornerRadius: CGFloat? = nil) {
        self.url = url
        self.imageSize = imageSize
        self.cornerRadius = cornerRadius
    }
    
    public var body: some View {
        Group {
            switch imageLoadStatePublisher.loadState {
            case .loading:
                HStack {
                    ProgressView()
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .frame(width: imageSize.width, height: imageSize.height)
            case .loaded(let image):
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: imageSize.width, height: imageSize.height)
                    .clipShape(RoundedRectangle(cornerRadius: cornerRadius ?? 0))
            default:
                HStack {
                    Image(systemName: "dog")
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .frame(width: imageSize.width, height: imageSize.height)
            }
        }
        .onAppear {
            loadImage()
        }
        .onDisappear {
            task?.cancel()
        }
    }
    
    func loadImage() {
        imageLoadStatePublisher.loadState = .loading
        
        if let cachedImage = ImageCache.shared.image(for: url) {
            imageLoadStatePublisher.loadState = .loaded(cachedImage)
            return
        }
        
        task?.cancel()
        
        task = Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                guard let image = UIImage(data: data) else {
                    DispatchQueue.main.async {
                        imageLoadStatePublisher.loadState = .failed(.invalidData)
                    }
                    return
                }
                
                ImageCache.shared.setImage(image, for: url)
                DispatchQueue.main.async {
                    imageLoadStatePublisher.loadState = .loaded(image)
                }
            } catch {
                DispatchQueue.main.async {
                    if let urlError = error as? URLError {
                        imageLoadStatePublisher.loadState = .failed(.networkError(urlError))
                    } else {
                        imageLoadStatePublisher.loadState = .failed(.unknownError)
                    }
                }
            }
        }
    }
}
