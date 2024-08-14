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
    @FocusState private var isInputFocused: Bool

    @State private var selectedBreed: Breed? = nil

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
                messages: breedMessageManager.messages,
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
                    await breedMessageManager.toggleLikeStatus(
                        imageId: breed.referenceImageId ?? "",
                        fetchedBreeds: fetchedBreeds
                    )
                }
            })
        }
        .onChange(of: breedMessageManager.command) {
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
                    await breedMessageManager.toggleLikeStatus(
                        imageId: imageId ?? "",
                        fetchedBreeds: fetchedBreeds
                    )
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
            CommandsView(
                items: Commands.allCases,
                iconBuilder: { $0.icon },
                titleBuilder: { Text($0.name) },
                action: { command in
                    breedMessageManager.command = command
                }
            )
        case false:
            EmptyView()
        }
    }
}

extension PersonalChatScreen {
    private func sendDraft(draft: String) {
        breedMessageManager.command = .search(draft)
    }
    
    private func loadData() async {
         fetchedBreeds.loadBreeds { breeds, error in
             Task {
                 if let breeds = breeds {
                     breedMessageManager.updateBreedMessages(from: breeds)
                     breedMessageManager.updateMessages(fetchedBreeds: fetchedBreeds)
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
        breedMessageManager.updateMessages(fetchedBreeds: fetchedBreeds)
    }
}
