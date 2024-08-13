//
//  ChatViewModel.swift
//  WB_Final
//
//  Created by Alina Potapova on 05.08.2024.
//

import SwiftUI
import ExyteChat

enum Command {
    case idle
    case all
    case favorite
}

final class ChatViewModel: ObservableObject {
    @Published var messages: [Message] = []
    @Published var command: Command = .idle

    func send(draft: DraftMessage) async {
        let newMessage = await Message.makeMessage(id: UUID().uuidString, user: User(id: "1", name: "Steve", avatarURL: nil, isCurrentUser: true), draft: draft)
            
        await MainActor.run {
            self.messages.append(newMessage)
            self.checkCommand(message: newMessage.text)
        }
    }
    
    func checkCommand(message: String) {
        switch message {
        case "Favorites", "Favorite", "Like", "Likes":
            self.command = .favorite
        case "All":
            self.command = .all
        default:
            return
        }
    }
}


//
//  ChatViewModel.swift
//  WB_Final
//
//  Created by Alina Potapova on 05.08.2024.
//
//
//import SwiftUI
//import ExyteChat
//import Combine
//import DogsAPI
//
//enum Command {
//    case idle
//    case all
//    case favorite
//}
//
//final class ChatViewModel: ObservableObject {
//    @Published var messages: [Message] = []
//    @Published var breedsMessages: [BreedMessage] = []
//    
//    @Published var command: Command = .idle
//    
//    private let interactor: ChatInteractorProtocol
//    private var subscriptions = Set<AnyCancellable>()
//    
//    init(interactor: ChatInteractorProtocol = BreedsChatInteractor()) {
//        self.interactor = interactor
//    }
//    
//    func send(draft: DraftMessage) {
//        interactor.send(draftMessage: draft)
//    }
//    
//    func onStart() {
//        interactor.messages
//            .compactMap { messages in
//                messages.map { $0 }
//            }
//            .assign(to: &$messages)
//        
//        loadMoreMessage()
//    }
//    
//    func loadMoreMessage() {
//        interactor.loadNextPage()
//            .sink { success in
//                if success {
//                    print("Next page loaded successfully")
//                } else {
//                    print("Failed to load next page")
//                }
//            }
//            .store(in: &subscriptions)
//    }
//    
//    func checkCommand(message: String) {
//        switch message {
//        case "Favorites", "Favorite", "Like", "Likes":
//            self.command = .favorite
//        case "All":
//            self.command = .all
//        default:
//            return
//        }
//    }
//}
//
//protocol ChatInteractorProtocol {
//    var messages: AnyPublisher<[Message], Never> { get }
//    func send(draftMessage: ExyteChat.DraftMessage)
//    func loadNextPage() -> Future<Bool, Never>
//}
//
//
//final class BreedsChatInteractor: ChatInteractorProtocol {
//    private let user = User(id: "1", name: "Dogs", avatarURL: nil, isCurrentUser: false)
//    private let currentUser = User(id: "2", name: "Me", avatarURL: nil, isCurrentUser: true)
//    
//    private let isActive: Bool
//    
//    private var isLoading = false
//    private var page = 1
//    
//    private var subscriptions = Set<AnyCancellable>()
//    
//    private lazy var chatState = CurrentValueSubject<[Message], Never>([])
//    private lazy var sharedState = chatState.share()
//    
//    var messages: AnyPublisher<[Message], Never> {
//        sharedState.eraseToAnyPublisher()
//    }
//    
//    init(isActive: Bool = false) {
//        self.isActive = isActive
//    }
//    
//    func send(draftMessage: ExyteChat.DraftMessage) {
//        Task {
//            let message = await Message.makeMessage(id: UUID().uuidString, user: currentUser, draft: draftMessage)
//            DispatchQueue.main.async { [weak self] in
//                self?.chatState.value.append(message)
//            }
//        }
//    }
//    
//    func loadNextPage() -> Future<Bool, Never> {
//        Future<Bool, Never> { [weak self] promise in
//            guard let self = self, !self.isLoading else {
//                promise(.success(false))
//                return
//            }
//            
//            self.isLoading = true
//            self.page += 1
//            
//            self.loadBreeds { data, error in
//                defer { self.isLoading = false }
//                if let data = data {
//                    let messages = data.map { $0.message }
//                    DispatchQueue.main.async {
//                        self.chatState.value = messages.reversed() + self.chatState.value
//                    }
//                    promise(.success(true))
//                } else {
//                    promise(.success(false))
//                }
//            }
//        }
//    }
//    
//    private func loadInitialBreeds() {
//        loadBreeds { data, error in
//            if let data = data {
//                let messages = data.map { $0.message }
//                DispatchQueue.main.async {
//                    self.chatState.value = messages
//                }
//            }
//        }
//    }
//    
//    func loadBreeds(completion: @escaping (_ data: [BreedMessage]?, _ error: Error?) -> Void) {
//        DogsAPI.getBreeds(limit: 10, page: self.page) { data, error in
//            if let error = error {
//                print("Error fetching breeds: \(error)")
//                completion(nil, error)
//            } else {
//                let breedMessages = data?.map { BreedMessage(breed: $0) } ?? []
//                completion(breedMessages, nil)
//            }
//        }
//    }
//}
