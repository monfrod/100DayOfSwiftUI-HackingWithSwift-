//
//  ContentView.swift
//  WordScramble
//
//  Created by yunus on 25.03.2025.
//

import SwiftUI

struct ContentView: View {
    
    @State private var usedWords: [String] = []
    @State private var newWord: String = ""
    @State private var rootWord: String = ""
    
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showError = false
    
    var body: some View {
        NavigationStack{
            List {
                Section {
                    TextField("Enter your word!", text: $newWord)
                        .textInputAutocapitalization(.never)
                        .onSubmit {
                            addNewWord()
                        }
                }
                
                Section {
                    ForEach(usedWords, id: \.self) { word in
                        HStack{
                            Image(systemName: "\(word.count).circle")
                            Text(word)
                        }
                    }
                }
            }
            .navigationTitle(rootWord)
            .onAppear {
                startGame()
            }
            .alert(errorTitle, isPresented: $showError) { } message: {
                Text(errorMessage)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Restart") {
                        startGame()
                    }
                }
            }
        }
    }
    
    func addNewWord(){
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard answer.count >= 3  else {
            wordAlert(title: "Word should be 3 or more letters!", message: "")
            newWord = ""
            return
        }
        
        guard isOriginal(word: answer) else {
            wordAlert(title: "Word used already", message: "Be more original!")
            newWord = ""
            return
        }
        
        guard isPossible(word: answer) else {
            wordAlert(title: "Word not possible", message: "You can't spell that word from '\(rootWord)'!")
            newWord = ""
            return
        }
        
        guard isReal(word: answer) else {
            wordAlert(title: "Word not recognized", message: "")
            newWord = ""
            return
        }
        
        withAnimation {
            usedWords.insert(answer, at: 0)
        }
        newWord = ""
    }
    
    func startGame(){
        usedWords = []
        if let startWords = Bundle.main.url(forResource: "start", withExtension: "txt"){
            if let words = try? String(contentsOf: startWords, encoding: .utf8) {
                let allWords = words.components(separatedBy: "\n")
                rootWord = allWords.randomElement() ?? "silkworm"
                return
            }
        }
        fatalError("Couldn't not load start.txt")
    }
    
    func isOriginal(word: String) -> Bool {
        !usedWords.contains(word)
    }
    
    func isPossible(word: String) -> Bool {
        var tempRoot = rootWord
        for letter in word {
            if let index = tempRoot.firstIndex(of: letter) {
                tempRoot.remove(at: index)
            } else {
                return false
            }
        }
        return true
    }
    
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        return misspelledRange.location == NSNotFound
    }
    
    func wordAlert(title: String, message: String){
        errorMessage = message
        errorTitle = title
        showError = true
    }
}

#Preview {
    ContentView()
}
