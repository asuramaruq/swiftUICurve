//
//  ContentView.swift
//  WordScramble
//
//  Created by Olzhas Imangeldin on 23.08.2025.
//

import SwiftUI

struct ContentView: View {
    
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    
    @State private var score = 0
    
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false
    
    
    func addNewWord() {
        
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
    
        guard answer.count > 2 else {
            wordError(title: "Too short", message: "Words must be at least 3 letters long.")
            return
        }
        guard answer != rootWord else {
            wordError(title: "That’s the root word!", message: "You can’t just use the start word.")
            return
        }
        
        guard isOriginal(word: answer) else {
            wordError(title: "Word used already", message: "Be more original")
            return
        }

        guard isPossible(word: answer) else {
            wordError(title: "Word not possible", message: "You can't spell that word from '\(rootWord)'!")
            return
        }

        guard isReal(word: answer) else {
            wordError(title: "Word not recognized", message: "You can't just make them up, you know!")
            return
        }
        
        withAnimation {
            usedWords.insert(answer, at: 0)
        }
        
        score += answer.count + 1
        
        newWord = ""
    }
    
    func startGame() {
        usedWords.removeAll()
        score = 0
        
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL, encoding: .utf8) {
                let allWords = startWords.components(separatedBy: "\n")

                rootWord = allWords.randomElement() ?? "silkworm"

                return
            }
        }

        fatalError("Could not load start.txt from bundle.")
    }
    
    
    func isOriginal (word: String) -> Bool {
        usedWords.contains(word) == false
    }
    
    func isPossible(word: String) -> Bool {
        var tempWord = rootWord

        for letter in word {
            if let pos = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: pos)
            } else {
                return false
            }
        }

        return true
    }
    
    func isReal (word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        return misspelledRange.location == NSNotFound
    }
    
    func wordError (title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showingError = true
    }
    
    var body: some View {
        NavigationStack {
            
            Text("Current score: \(score)")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            
            List {
                
                Section {
                    TextField("Enter your word: ", text: $newWord)
                }
                
                Section {
                    
                    ForEach (usedWords, id: \.self) { word in
                        HStack {
                            Image(systemName: "\(word.count).circle")
                            Text(word)
                        }
                    }
                    
                }
                
            }
            .onAppear(perform: startGame)
            .alert(errorTitle, isPresented: $showingError) { } message: {
                Text(errorMessage)
            }
            .navigationTitle(rootWord)
            .onSubmit(addNewWord)
            .textInputAutocapitalization(.never)
            .toolbar(){
                Button("Restart", action: startGame)
            }
        }
    }
}

#Preview {
    ContentView()
}
