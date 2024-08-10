//
//  PersonalChatView.swift
//  WBApp
//
//  Created by Alina Potapova on 05.08.2024.
//

import SwiftUI
import UISystem
import ExyteChat

struct PersonalChatView: View {
    @EnvironmentObject var fetchedBreeds: FetchedBreeds
    @FocusState private var isInputFocused: Bool
    @StateObject private var vm: ChatVM
    
    init(vm: ChatVM = ChatVM()) {
        _vm = StateObject(wrappedValue: vm)
    }
    
    var body: some View {
        VStack {
            NavigationBarView(
                title: "Анастасия И.",
                leadingIcon: UI.Icons.back,
                trailingIcon: UI.Icons.search,
                additionalTrailingIcon: UI.Icons.lines,
                leadingAction: { isInputFocused = false},
                trailingAction: {},
                additionalTrailingAction: {}
            )
            
            ChatView(
                messages: vm.messages,
                chatType: .conversation,
                didSendMessage: sendDraft,
                messageBuilder: messageViewBuilder,
                inputViewBuilder: inputViewBuilder,
                messageMenuAction: messageMenuAction
            )
            .headerBuilder(chatHeaderView)
            .chatTheme(colors: ChatTheme.Colors(
                mainBackground: Color.theme.offWhite
            ))
            .task {
                await loadData()
            }
        }
        .background(Color.theme.white)
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
        ChatMessageView(message: message, positionInUserGroup: positionInGroup)
            .onTapGesture {
                isInputFocused = false
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

    private func messageMenuAction(
        action: DefaultMessageMenuAction,
        defaultActionClosure: (Message, DefaultMessageMenuAction) -> Void,
        message: Message
    ) {
        switch action {
        case .reply:
            defaultActionClosure(message, .reply)
            isInputFocused = true
        case .edit:
            ()
        }
    }
    
    private func loadData() async {
        fetchedBreeds.loadBreeds { data, error in
            if let breeds = data {
                let messages = breeds.map { $0.toMessage() }
                vm.messages.append(contentsOf: messages)
            }
        }
        
        fetchedBreeds.loadFavorites { data, error in
        }
    }
}

#Preview {
    PersonalChatView()
}
