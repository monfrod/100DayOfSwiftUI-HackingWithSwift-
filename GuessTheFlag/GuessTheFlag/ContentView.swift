//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by yunus on 02.02.2024.
//

import SwiftUI

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "UK", "Italy", "Germany",
                     "Ukraine", "Poland", "Spain", "Nigeria",
                                    "Monaco", "Ireland", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var scoreTitle = ""
    @State private var showAlert = false
    @State private var showAlertRound = false
    @State private var score = 0
    @State private var round = 0
    @State private var rotationDegrees = [0.0, 0.0, 0.0]
    @State private var opacity = [1.0, 1.0, 1.0]
    @State private var scale = [1.0, 1.0, 1.0]
    
    var body: some View {
        ZStack{
            LinearGradient(colors: [.purple, .green], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            VStack(spacing: 30){
                VStack{
                    Text("Tap the flag off")
                        .foregroundStyle(.white)
                        .font(.subheadline.weight(.heavy))
                    Text(countries[correctAnswer])
                        .foregroundStyle(.white)
                        .font(.largeTitle.weight(.semibold))
                }
                ForEach(0..<3) { number in
                    Button {
                        withAnimation(.easeInOut(duration: 1)) {
                            rotationDegrees[number] += 360
                            for i in 0..<3 {
                                if i == number {
                                    scale[i] = 1.0 // Выбранный флаг остается нормального размера
                                } else {
                                    opacity[i] = 0.25 // Остальные становятся полупрозрачными
                                    scale[i] = 0.8 // И уменьшаются
                                }
                            }
                        }
                        flagTapped(number)
                    } label: {
                        Image(countries[number])
                            .clipShape(.rect(cornerRadius: 7))
                            .shadow(radius: 10)
                            .rotationEffect(.degrees(rotationDegrees[number]))
                            .opacity(opacity[number])
                            .scaleEffect(scale[number])
                    }
                }
            }
        }
        .alert(scoreTitle, isPresented: $showAlert){
            Button("Continue", action: askQuestions)
        } message: {
                Text("Your score is \(score)")
        }
        .alert("Game over", isPresented: $showAlertRound){
            Button("Play again", action: reset)
        } message: {
            Text("Your final score is \(score)")
        }
    }
    func flagTapped(_ number: Int){
        round += 1
        if number == correctAnswer{
            scoreTitle = "Correct"
            score += 1
        } else {
            scoreTitle = "Wrong, you choose \(countries[number]) flag"
            score -= 1
        }
        showAlert = true
        if round == 8 {
            showAlertRound = true
        }
    }
    func askQuestions() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        rotationDegrees = [0.0, 0.0, 0.0]
        opacity = [1.0, 1.0, 1.0]
        scale = [1.0, 1.0, 1.0]
    }
    func reset(){
        score = 0
        round = 0
    }
}

#Preview {
    ContentView()
}
