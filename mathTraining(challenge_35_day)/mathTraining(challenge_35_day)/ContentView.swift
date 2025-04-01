//
//  ContentView.swift
//  mathTraining(challenge_35_day)
//
//  Created by yunus on 29.03.2025.
//

import SwiftUI

struct ContentView: View {
    
    private let arrayCountOfQuestions = [5, 10, 15, 20]
    @State private var levelSettings = 10
    @State private var countOfQuestions = 10
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Text("До скольки вы хотите выучить таблицу умножения?")
                    Stepper("До \(levelSettings)", value: $levelSettings, in: 2...12)
                }
                Section {
                    Text("Сколько вопросов вы хотите получить?")
                    Picker("", selection: $countOfQuestions) {
                        ForEach(arrayCountOfQuestions, id: \.self) { number in
                            Text("\(number)")
                        }
                    }
                    .pickerStyle(.segmented)
                }
            }
            .navigationTitle("Таблица умножения")
            Button {
                print("it's worked")
                
                NavigationLink("") {
                    
                }
            } label: {
                Text("Начать игру 🚀")
                    .padding()
                    .background(.blue)
                    .foregroundStyle(.white)
                    .clipShape(.capsule)
            }

        }
    }
}

#Preview {
    ContentView()
}
