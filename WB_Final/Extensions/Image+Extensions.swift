////
////  Image+Extensions.swift
////  WB_Final
////
////  Created by Alina Potapova on 10.08.2024.
////
//
//import SwiftUI
//
//extension UIImage {
//    var isPortrait: Bool {
//        size.height > size.width
//    }
//}
//
//extension Image {
//    func isPortrait(url: URL) -> Bool {
//        guard let uiImage = self.asUIImage() else {
//            return false
//        }
//        return uiImage.isPortrait
//    }
//
//
//    private func asUIImage(url: URL) -> UIImage? {
//        do {
//            let imageData = try Data(contentsOf: url)
//            return UIImage(data: imageData)
//        } catch {
//            print(error.localizedDescription)
//            return nil
//        }
//    }
//    
//
//    private func toUIImageData() -> Data? {
//        guard let uiImage = UIImage(systemName: "photo") else {
//            return nil
//        }
//        return uiImage.pngData()
//    }
//}
