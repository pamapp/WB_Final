//
//  Constants.swift
//  WB_Final
//
//  Created by Alina Potapova on 10.08.2024.
//

import SwiftUI

enum UI {
    enum Strings {
        static var send: String { localizedString(for: .send) }
        static var sending: String { localizedString(for: .sending) }
        static var read: String { localizedString(for: .read) }
        static var error: String { localizedString(for: .error) }
        
        static func localizedString(for key: LocalizationKeys) -> String {
            return NSLocalizedString(key.rawValue, comment: key.rawValue)
        }
    }
    
    enum Icons {
        static let search: String = "search"
        static let plus: String = "plus"
        static let back: String = "chevron.left"
        static let mic: String = "mic"
        static let paperplane: String = "paperplane"
        static let lines: String = "lines"
        static let pauseAudio: String = "pauseAudio"
        static let playAudio: String = "playAudio"
    }
}
