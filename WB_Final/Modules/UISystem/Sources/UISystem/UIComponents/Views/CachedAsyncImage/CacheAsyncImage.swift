//
//  CachedAsyncImage.swift
//  WB_Final
//
//  Created by Alina Potapova on 10.08.2024.
//

import SwiftUI

public struct CachedAsyncImage: View {
    var url: URL
    var imageSize: (width: CGFloat?, height: CGFloat?)
    var cornerRadius: CGFloat?
    
    @State private var loadState: ImageLoadState = .idle
    @State private var task: Task<Void, Never>? = nil
    
    enum ImageLoadState {
        case idle
        case loading
        case loaded(UIImage)
        case failed
    }
    
    public init(url: URL, imageSize: (width: CGFloat?, height: CGFloat?), cornerRadius: CGFloat? = nil) {
        self.url = url
        self.imageSize = imageSize
        self.cornerRadius = cornerRadius
    }
    
    public var body: some View {
        Group {
            switch loadState {
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
                Image(systemName: "dog")
                    .resizable()
                    .scaledToFit()
                    .frame(width: imageSize.width, height: imageSize.height)
                    .clipShape(RoundedRectangle(cornerRadius: cornerRadius ?? 0))
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
        loadState = .loading
        
        if let cachedImage = ImageCache.shared.image(for: url) {
            self.loadState = .loaded(cachedImage)
            return
        }
        
        task?.cancel()
        
        task = Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                guard let image = UIImage(data: data) else {
                    DispatchQueue.main.async {
                        self.loadState = .failed
                    }
                    return
                }
                
                ImageCache.shared.setImage(image, for: url)
                DispatchQueue.main.async {
                    self.loadState = .loaded(image)
                }
            } catch {
                DispatchQueue.main.async {
                    self.loadState = .failed
                }
            }
        }
    }
}
