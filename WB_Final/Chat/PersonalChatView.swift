//
//  PersonalChatView.swift
//  WBApp
//
//  Created by Alina Potapova on 05.08.2024.
//

import SwiftUI
import UISystem
import ExyteChat
import DogsAPI

struct PersonalChatView: View {
    @EnvironmentObject var fetchedBreeds: FetchedBreeds
    @FocusState private var isInputFocused: Bool
    @StateObject private var vm: ChatViewModel
    
    @State private var selectedBreed: Breed? = nil

    init(vm: ChatViewModel = ChatViewModel()) {
        _vm = StateObject(wrappedValue: vm)
    }
    
    var body: some View {
        VStack {
            NavigationBarView(
                title: "Dogs",
                leadingIcon: UI.Icons.back,
                trailingIcon: UI.Icons.search,
                additionalTrailingIcon: UI.Icons.lines,
                leadingAction: { isInputFocused = false },
                trailingAction: {},
                additionalTrailingAction: {}
            )
            
            ChatView(
                messages: vm.messages,
                chatType: .conversation,
                didSendMessage: sendDraft,
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
    }
}

extension PersonalChatView {
    @ViewBuilder
    private func messageViewBuilder(
        message: Message,
        positionInGroup: PositionInUserGroup,
        positionInCommentsGroup: CommentsPosition?,
        showContextMenuClosure: @escaping () -> Void,
        messageActionClosure: @escaping (Message, DefaultMessageMenuAction) -> Void,
        showAttachmentClosure: @escaping (Attachment) -> Void
    ) -> some View {
        let breedMessage = fetchedBreeds.breedMessages.first(where: { $0.message.id == message.id })
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
    
    @ViewBuilder
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
            inputViewActionClosure: inputViewActionClosure
        )
        .focused($isInputFocused)
    }
    
    @ViewBuilder
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
}

extension PersonalChatView {
    private func sendDraft(draft: DraftMessage) {
        if !draft.text.isEmpty || !draft.medias.isEmpty || draft.recording != nil {
            Task {
                await vm.send(draft: draft)
            }
        }
    }
    
    private func loadData() async {
        fetchedBreeds.loadBreeds { breedMessages, error in
            if let breedMessages = breedMessages {
                vm.messages = breedMessages.map { $0.message }
            }
        }
        
        fetchedBreeds.loadFavorites { data, error in
            fetchedBreeds.favoriteBreeds = data ?? []
        }
    }
}

// MARK: - Actions

extension PersonalChatView {
    private func toggleLikeStatus(imageId: String) async {
        if fetchedBreeds.isBreedFavorited(imageId) {
            _ = await removeFavorite(imageId)
        } else {
            _ = await addFavorite(imageId)
        }
    }
    
    private func addFavorite(_ imageId: String) async -> Bool {
        await fetchedBreeds.addFavorite(imageId: imageId, subId: "user")
    }

    private func removeFavorite(_ imageId: String) async -> Bool {
        guard let favorite = fetchedBreeds.favoriteBreeds.first(where: { $0.imageId == imageId }) else {
            return false
        }
        
        return await fetchedBreeds.removeFavorite(id: favorite.id)
    }
}
