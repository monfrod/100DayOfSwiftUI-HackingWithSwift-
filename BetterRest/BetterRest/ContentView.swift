//
//  ContentView.swift
//  BetterRest
//
//  Created by yunus on 20.03.2025.
//

import SwiftUI
import CoreML

struct ContentView: View {
    
    @State private var wakeUp = Date.now
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 2
    
    @State private var alertTitle = ""
    @State private var alertMessages = ""
    @State private var showAlert = false
    @State private var isVisible = false
    
    @State private var isSection1Visible = false
    @State private var isSection2Visible = false
    @State private var isSection3Visible = false
    @State private var isButtonVisible = false
    
    var body: some View {
        ScrollView {
            Text("BetterRest")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 20)
            
            VStack(spacing: 20) {
                sectionView(title: "Во сколько вы хотите встать?", content: {
                    DatePicker("", selection: $wakeUp, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                        .datePickerStyle(.compact)
                })
                .opacity(isSection1Visible ? 1 : 0)
                .animation(.easeInOut(duration: 0.5), value: isSection1Visible)

                sectionView(title: "Сколько часов хотите спать?", content: {
                    Picker("\(sleepAmount, specifier: "%.2f") часов", selection: $sleepAmount) {
                        ForEach(Array(stride(from: 4.0, through: 12.0, by: 0.25)), id: \.self) { hour in
                            Text("\(hour, specifier: "%.2f")")
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                })
                .opacity(isSection2Visible ? 1 : 0)
                .animation(.easeInOut(duration: 0.5).delay(0.3), value: isSection2Visible)

                sectionView(title: "Сколько чашек кофе вы пьете в день?", content: {
                    Picker("\(coffeeAmount) чашек кофе", selection: $coffeeAmount) {
                        ForEach(0...20, id: \.self) { cup in
                            Text("\(cup) чашек")
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                })
                .opacity(isSection3Visible ? 1 : 0)
                .animation(.easeInOut(duration: 0.5).delay(0.6), value: isSection3Visible)

                Button(action: calculateBedTime) {
                    Text("Вычислить")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(LinearGradient(gradient: Gradient(colors: [.blue, .purple]), startPoint: .leading, endPoint: .trailing))
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .shadow(radius: 5)
                }
                .opacity(isButtonVisible ? 1 : 0)
                .animation(.easeInOut(duration: 0.5).delay(0.6), value: isButtonVisible)
                .padding(.horizontal)
            }
            .padding()
        }
        .opacity(isVisible ? 1 : 0)
        .animation(.easeInOut(duration: 1.0), value: isVisible)
        .background(Color(.systemGroupedBackground))
        .alert(alertTitle, isPresented: $showAlert) {
            Button("Ок") { }
        } message: {
            Text(alertMessages)
        }
        .navigationTitle("BetterRest")
        .onAppear {
            isVisible = true
            isSection1Visible = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                isSection2Visible = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                isSection3Visible = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                isButtonVisible = true
            }
        }
    }
    
    @ViewBuilder
    func sectionView<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
            content()
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .shadow(radius: 5)
    }
    
    func calculateBedTime(){
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            
            let date = Calendar.current.dateComponents([.minute, .hour], from: wakeUp)
            let hour = (date.hour ?? 0) * 60 * 60
            let minute = (date.minute ?? 0) * 60
            
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            let timeSleep = wakeUp - prediction.actualSleep
            
            alertTitle = "Ваш идеальное время ложиться спать это"
            alertMessages = "\(timeSleep.formatted(date: .omitted, time: .shortened))"
            
        } catch {
            alertTitle = "Упс.."
            alertMessages = "что то пошло не так :("
        }
        showAlert = true
    }
}

#Preview {
    ContentView()
}
