//
//  ImageCyche.swift
//  WB_Final
//
//  Created by Андрей on 11.08.2024.
//

import Foundation
import SwiftUI
import Combine
import os.log

class ImageCache {
    static let shared = ImageCache()
    
    private var cache = [URL: CachedImage]()
    private var order = [URL]()
    private var totalSize: Int = 0
    private let maxCacheSize: Int = 50 * 1024 * 1024
    private let maxImageCount: Int = 100
    private let lock = NSLock()
    private let logger = Logger(subsystem: "com.pamapp.WB-Final.imagecache", category: "ImageCache")
    
    private init() {}
    
    func image(for url: URL) -> UIImage? {
        lock.lock()
        defer { lock.unlock() }
        return cache[url]?.image
    }
    
    func setImage(_ image: UIImage, for url: URL) {
        lock.lock()
        defer { lock.unlock() }
        
        let imageData = image.jpegData(compressionQuality: 0.8) ?? Data()
        let imageSize = imageData.count
        
        while totalSize + imageSize > maxCacheSize || cache.count >= maxImageCount {
            removeOldestImage()
        }
        
        cache[url] = CachedImage(image: image, size: imageSize)
        totalSize += imageSize
        order.append(url)
        
    }
    
    private func removeOldestImage() {
        guard let oldestURL = order.first else { return }
        if let cachedImage = cache.removeValue(forKey: oldestURL) {
            totalSize -= cachedImage.size
            order.removeFirst()
            
            logger.info("Removed oldest image from cache for URL: \(oldestURL.absoluteString). Freed \(cachedImage.size) bytes. Total cache size: \(self.totalSize) bytes.")
            
        }
    }
    
    private struct CachedImage {
        let image: UIImage
        let size: Int
    }
}
