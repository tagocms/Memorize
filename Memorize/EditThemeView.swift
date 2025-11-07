//
//  EditThemeView.swift
//  Memorize
//
//  Created by Tiago Camargo Maciel dos Santos on 06/11/25.
//

import SwiftUI

struct EditThemeView: View {
    enum FocusStates {
        case name, emojis
    }
    @Binding var theme: EmojiTheme
    @FocusState var focusState: FocusStates?
    @State private var emojisToAdd: String = ""
    @GestureState private var dragGestureOffset: CGSize = .zero
    @State private var emojiBeingDragged: String?
    @State private var scaleEffect: CGFloat = 1
    @State private var isCollision = false
    
    let screenWidth: CGFloat = UIScreen.main.bounds.maxX
    
    var body: some View {
        Form {
            headerSection
            numberOfPairsSection
            emojisSection
        }
        .animation(.default, value: theme.emojis)
        .onAppear {
            if theme.name.isEmpty {
                focusState = .name
            } else {
                focusState = .emojis
            }
        }
        .onChange(of: emojiBeingDragged) {
            if emojiBeingDragged != nil {
                scaleEffect = 1.1
            } else {
                scaleEffect = 1
            }
        }
    }
    
    var headerSection: some View {
        Section("header") {
            TextField("Name", text: $theme.name)
                .focused($focusState, equals: .name)
            
            ColorPicker("Color Picker", selection: $theme.colorView, supportsOpacity: true)
        }
    }
    
    var emojisSection: some View {
        // TODO: Terminar de fazer a deleção de emojis
        Section("emojis") {
            addEmojisTextField
            registeredEmojis
        }
    }
    
    var numberOfPairsSection: some View {
        Section("number of pairs") {
            Toggle("Fixed number of pairs", isOn: $theme.showsFixedNumberOfCards)
            if theme.showsFixedNumberOfCards {
                HStack {
                    Text("\(theme.numberOfPairs)")
                    Stepper("pairs", value: $theme.numberOfPairs, in: 2...max(theme.emojis.count, 2))
                }
            }
        }
    }
    
    var addEmojisTextField: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Add emojis")
                    .font(.title3.bold())
                TextField("Add emojis here", text: $emojisToAdd)
                    .focused($focusState, equals: .emojis)
            }
            addEmojisButtons
        }
    }
    
    var addEmojisButtons: some View {
        HStack(spacing: 20) {
            Button("Clear") {
                emojisToAdd = ""
            }
            .buttonStyle(.plain)
            .foregroundStyle(.blue)
            
            Button("Save") {
                var cleanedEmojis = emojisToAdd.trimmingCharacters(in: .whitespacesAndNewlines)
                cleanedEmojis = cleanedEmojis.filter { $0.isEmoji }
                let emojisToAddArray = cleanedEmojis.map { String($0) }.uniqued
                theme.emojis.append(contentsOf: emojisToAddArray)
                emojisToAdd = ""
            }
            .buttonStyle(.plain)
            .foregroundStyle(.blue)
        }
    }
    
    @ViewBuilder
    var registeredEmojis: some View {
        let columns = [GridItem(.adaptive(minimum: 40), spacing: 4, alignment: .center)]
        
        GeometryReader { geometry in
            VStack(alignment: .leading) {
                registeredEmojisHeader
                LazyVGrid(columns: columns) {
                    ForEach(theme.emojis.uniqued, id: \.self) { emoji in
                        Text(emoji)
                            .offset(emoji == emojiBeingDragged ? dragGestureOffset : .zero)
                            .gesture(dragGesture(for: emoji, geometry: geometry))
                            .scaleEffect(emoji == emojiBeingDragged ? scaleEffect : 1)
                    }
                }
            }
        }
        .frame(height: max(120, CGFloat(ceil(Double(theme.emojis.count) / 8.0)) * 48))
    }
    
    var registeredEmojisHeader: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Registered emojis")
                    .font(.title3.bold())
                Text("Drag the emoji to the trash to remove it")
                    .font(.subheadline.italic())
            }
            Spacer()
            if emojiBeingDragged != nil {
                Image(systemName: "trash")
                    .font(.title2)
                    .foregroundStyle(.red)
                    .scaleEffect(isCollision ? scaleEffect : 1)
                    .background(
                        // This will help us identify the trash area
                        RoundedRectangle(cornerRadius: 8)
                            .fill(isCollision ? Color.red.opacity(0.3) : Color.clear)
                            .frame(width: 50, height: 50)
                    )
            }
        }
    }
    
    private func dragGesture(for emoji: String, geometry: GeometryProxy) -> some Gesture {
        DragGesture()
            .updating($dragGestureOffset) { offset, dragGestureOffset, _ in
                withAnimation {
                    if emojiBeingDragged == nil {
                        emojiBeingDragged = emoji
                    }
                    dragGestureOffset = offset.translation
                    isCollision = checkCollision(for: offset, in: geometry)
                }
            }
            .onEnded { offset in
                withAnimation {
                    if checkCollision(for: offset, in: geometry) {
                        theme.emojis.remove(emoji)
                    }
                    emojiBeingDragged = nil
                    isCollision = false
                }
            }
    }
    
    private func checkCollision(for offset: GestureStateGesture<DragGesture, CGSize>.Value, in geometry: GeometryProxy) -> Bool {
        // Calculate collision with trash icon area
        // Trash is positioned in the top-right of the header
        let trashX = geometry.frame(in: .local).maxX // Approximate trash position
        let trashY: CGFloat = 0 // Approximate trash Y position
        let trashSize: CGFloat = 50
        
        let currentEmojiX = offset.location.x
        let currentEmojiY = offset.location.y
        print("Current emoji x: \(currentEmojiX)")
        
        // Check if emoji is within trash area
        let isInTrashArea = currentEmojiX >= trashX - trashSize &&
                         currentEmojiX <= trashX + trashSize &&
                         currentEmojiY >= trashY - trashSize &&
                         currentEmojiY <= trashY + trashSize
        
        return isInTrashArea
    }
}

#Preview {
    @Previewable @State var theme = EmojiTheme.defaultTheme
    return EditThemeView(theme: $theme)
}
