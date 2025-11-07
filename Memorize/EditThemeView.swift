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
    @State private var emojiInitialPositions: [String: CGPoint] = [:]
    @State private var trashPosition: CGPoint = .zero
    
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
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
            }
            addEmojisButtons
        }
    }
    
    var addEmojisButtons: some View {
        HStack(spacing: 20) {
            Button("Clear", role: .destructive) {
                emojisToAdd = ""
            }
            .buttonStyle(.plain)
            .foregroundStyle(.red)
            
            Button("Add") {
                var cleanedEmojis = emojisToAdd.trimmingCharacters(in: .whitespacesAndNewlines)
                cleanedEmojis = cleanedEmojis.filter { $0.isEmoji }
                let emojisToAddArray = cleanedEmojis.map { String($0) }.uniqued
                theme.emojis.append(contentsOf: emojisToAddArray)
                emojisToAdd = ""
            }
            .buttonStyle(.plain)
            .foregroundStyle(.blue)
        }
        .disabled(emojisToAdd.isEmpty)
    }
    
    @ViewBuilder
    var registeredEmojis: some View {
        let columns = [GridItem(.adaptive(minimum: 40), spacing: 4, alignment: .center)]
        
        VStack(alignment: .leading) {
            registeredEmojisHeader
            LazyVGrid(columns: columns) {
                ForEach(theme.emojis.uniqued, id: \.self) { emoji in
                    emojiText(for: emoji)
                }
            }
        }
    }
    
    var registeredEmojisHeader: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Registered emojis")
                    .font(.title3.bold())
                Text(focusState == nil ? "Drag an emoji to remove it" : "Added emojis will appear here")
                    .font(.subheadline.italic())
            }
            Spacer()
            if emojiBeingDragged != nil {
                Image(systemName: "trash")
                    .font(.title2)
                    .foregroundStyle(.red)
                    .scaleEffect(isCollision ? scaleEffect : 1)
                    .background(
                        GeometryReader { geometry in
                            Color.clear
                                .onAppear {
                                    trashPosition = geometry.frame(in: .global).center
                                }
                        }
                    )
            }
        }
    }
    
    private func emojiText(for emoji: String) -> some View {
        Text(emoji)
            .background(
                GeometryReader { geometry in
                    Color.clear
                        .onAppear {
                            emojiInitialPositions[emoji] = geometry.frame(in: .global).center
                        }
                        .onChange(of: theme.emojis) {
                            emojiInitialPositions[emoji] = geometry.frame(in: .global).center
                        }
                }
            )
            .offset(emoji == emojiBeingDragged ? dragGestureOffset : .zero)
            .gesture(dragGesture(for: emoji))
            .allowsHitTesting(focusState == nil)
    }
    
    private func dragGesture(for emoji: String) -> some Gesture {
        DragGesture()
            .updating($dragGestureOffset) { offset, dragGestureOffset, _ in
                withAnimation {
                    if emojiBeingDragged == nil {
                        emojiBeingDragged = emoji
                    }
                    dragGestureOffset = offset.translation
                    isCollision = checkCollision(for: offset)
                }
            }
            .onEnded { offset in
                withAnimation {
                    if checkCollision(for: offset) {
                        theme.emojis.remove(emoji)
                    }
                    emojiBeingDragged = nil
                    isCollision = false
                }
            }
    }
    
    private func checkCollision(for offset: GestureStateGesture<DragGesture, CGSize>.Value) -> Bool {
        if let emojiBeingDragged,
           var emojiPosition = emojiInitialPositions[emojiBeingDragged] {
            
            emojiPosition.x += offset.translation.width
            emojiPosition.y += offset.translation.height
            
            if emojiPosition.distance(to: trashPosition) < 50 {
                return true
            }
        }
        return false
    }
}

#Preview {
    @Previewable @State var theme = EmojiTheme.defaultTheme
    return EditThemeView(theme: $theme)
}

extension CGRect {
    var center: CGPoint {
        return CGPoint(x: midX, y: midY)
    }
}

extension CGPoint {
    func distance(to other: CGPoint) -> CGFloat {
        sqrt(pow(x - other.x, 2) + pow(y - other.y, 2))
    }
}
