//
//  PersonalChatView.swift
//  WBApp
//
//  Created by Alina Potapova on 05.08.2024.

import SwiftUI
import UISystem
import ExyteChat
import DogsAPI

struct PersonalChatScreen: View {
    @EnvironmentObject var fetchedBreeds: DogBreedService
    @EnvironmentObject var breedMessageManager: BreedMessageManager
    
    @StateObject private var vm: ChatViewModel
    @FocusState private var isInputFocused: Bool

    @State private var selectedBreed: Breed? = nil

    init(vm: ChatViewModel = ChatViewModel()) {
        _vm = StateObject(wrappedValue: vm)
    }
    
    var body: some View {
        VStack {
            NavigationBarView(
                title: UI.Strings.dogBreeds,
                leadingIcon: UI.Icons.back,
                additionalTrailingIcon: UI.Icons.lines,
                leadingAction: { isInputFocused = false },
                additionalTrailingAction: {}
            )
            
            ChatView(
                messages: vm.messages,
                chatType: .conversation,
                didSendMessage: { _ in },
                messageBuilder: messageViewBuilder,
                inputViewBuilder: inputViewBuilder
            )
            .headerBuilder(chatHeaderView)
            .showMessageMenuOnLongPress(false)
            .chatTheme(colors: ChatTheme.Colors(
                mainBackground: Color.theme.offWhite,
                messageMenuBackground: Color.theme.active,
                friendMessage: Color.theme.white
            ))
            .task {
                await loadData()
            }
        }
        .background(Color.theme.white)
        .fullScreenCover(item: $selectedBreed) { breed in
            BreedDetailView(breed: breed, tapLike: {
                Task {
                    await toggleLikeStatus(imageId: breed.referenceImageId ?? "")
                }
            })
        }
        .onChange(of: vm.command) {
            Task {
                await updateData()
            }
        }
    }
}

extension PersonalChatScreen {

    @ViewBuilder
    private func messageViewBuilder(
        message: Message,
        positionInGroup: PositionInUserGroup,
        positionInCommentsGroup: CommentsPosition?,
        showContextMenuClosure: @escaping () -> Void,
        messageActionClosure: @escaping (Message, DefaultMessageMenuAction) -> Void,
        showAttachmentClosure: @escaping (Attachment) -> Void
    ) -> some View {
        let breedMessage = breedMessageManager.breedMessages.first(where: { $0.message.id == message.id })
        let imageId = breedMessage?.breed.referenceImageId
        
        ChatMessageView(
            message: message,
            positionInUserGroup: positionInGroup, 
            tapLike: {
                Task {
                    await toggleLikeStatus(imageId: imageId ?? "")
                }
            }
        )
        .onTapGesture {
            isInputFocused = false
            selectedBreed = breedMessage?.breed
        }
    }
    
    private func inputViewBuilder(
        textBinding: Binding<String>,
        attachments: InputViewAttachments,
        inputViewState: InputViewState,
        inputViewStyle: InputViewStyle,
        inputViewActionClosure: @escaping (InputViewAction) -> Void,
        dismissKeyboardClosure: ()->()
    ) -> some View {
        ChatInputView(
            text: textBinding,
            attachments: attachments,
            inputViewStyle: inputViewStyle,
            inputViewState: inputViewState,
            inputViewActionClosure: sendDraft 
        )
        .commandSectionView(commandsView)
        .focused($isInputFocused)
    }
    
    private func chatHeaderView(with date: Date) -> some View {
        HStack(spacing: 16) {
            VStack { Divider() }
            
            Text(date.dateToString("E, d MMM"))
                .font(.metadata1())
                .foregroundStyle(Color.theme.disabled)
            
            VStack { Divider() }
        }
        .frame(height: 20)
        .padding(.horizontal, 16)
    }
    
    @ViewBuilder
    private func commandsView() -> some View {
        switch isInputFocused {
        case true:
            HStack(spacing: 16) {
                Button(action: { vm.command = .all }) {
                    HStack {
                        Image(systemName: "dog")
                        Text("All")
                    }
                }
                .buttonStyle(CommandButtonStyle())

                
                Button(action: { vm.command = .favorite }) {
                    HStack {
                        Image(UI.Icons.heart)
                        Text("Favorites")
                    }
                }
                .buttonStyle(CommandButtonStyle())
                
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .frame(height: 30)
            .padding(.horizontal, 16)
            .padding(.top, 8)
            .background(Color.theme.white)
        case false:
            EmptyView()
        }
    }
}

extension PersonalChatScreen {
    private func sendDraft(draft: String) {
        vm.command = .search(draft)
    }
    
    private func loadData() async {
        fetchedBreeds.loadBreeds { breeds, error in
            Task {
                if let breeds = breeds {
                    breedMessageManager.updateBreedMessages(from: breeds)
                    await MainActor.run {
                        vm.messages = breedMessageManager.getMessages()
                    }
                }
            }
        }

        fetchedBreeds.loadFavorites { data, error in
            Task {
                await MainActor.run {
                    fetchedBreeds.favoriteBreeds = data ?? []
                }
            }
        }
    }

    private func updateData() async {
        switch vm.command {
        case .favorite:
            let favoriteBreedMessages = breedMessageManager.getFavoriteBreedMessages(favoriteImageIds: fetchedBreeds.getFavoriteImageIds())
            let favoriteMessages = favoriteBreedMessages.map { $0.message }

            await MainActor.run {
                if !favoriteMessages.isEmpty {
                    vm.messages = favoriteMessages
                }
            }

        case .search(let searchString):
            breedMessageManager.updateBreedMessages(from: fetchedBreeds.breeds)
            let filteredMessages = breedMessageManager.getMessages().filtered(by: searchString)
            
            await MainActor.run {
                if !filteredMessages.isEmpty {
                    vm.messages = filteredMessages
                }
            }

        default:
            breedMessageManager.updateBreedMessages(from: fetchedBreeds.breeds)
            let allMessages = breedMessageManager.getMessages()

            await MainActor.run {
                if !allMessages.isEmpty {
                    vm.messages = allMessages
                }
            }
        }
    }
}

// MARK: - Actions

extension PersonalChatScreen {
    private func toggleLikeStatus(imageId: String) async {
        if fetchedBreeds.isBreedFavorite(imageId) {
            _ = await removeFavorite(imageId)
        } else {
            _ = await addFavorite(imageId)
        }
    }
    
    private func addFavorite(_ imageId: String) async -> Bool {
        await fetchedBreeds.addFavorite(imageId: imageId)
    }

    private func removeFavorite(_ imageId: String) async -> Bool {
        guard let favorite = fetchedBreeds.favoriteBreeds.first(where: { $0.imageId == imageId }) else {
            return false
        }
        
        return await fetchedBreeds.removeFavorite(id: favorite.id)
    }
}
