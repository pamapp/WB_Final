//
//  CachedAsyncImage.swift
//  WB_Final
//
//  Created by Андрей & Alina Potapova on 10.08.2024.
//

import SwiftUI
import ExyteChat
import os.log

public struct CachedAsyncImage: View {
    var url: URL
    var imageSize: (width: CGFloat?, height: CGFloat?)
    var cornerRadius: CGFloat?
    
    @StateObject private var imageLoadStatePublisher = ImageLoadStatePublisher()
    @State private var task: Task<Void, Never>? = nil
    
    private let logger = OSLog(subsystem: Bundle.main.bundleIdentifier ?? "com.pamapp.WB-Final.attachment", category: "ImageLoading")
    
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
                        os_log("Failed to decode image data from URL: %{public}@", log: logger, type: .error, url.absoluteString)
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
//                        os_log("Network error occurred: %{public}@", log: logger, type: .error, urlError.localizedDescription)
                        imageLoadStatePublisher.loadState = .failed(.networkError(urlError))
                    } else {
                        os_log("Unknown error occurred: %{public}@", log: logger, type: .error, error.localizedDescription)
                        imageLoadStatePublisher.loadState = .failed(.unknownError)
                    }
                }
            }
        }
    }
}
