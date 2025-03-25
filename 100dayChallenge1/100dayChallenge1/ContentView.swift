//
//  ContentView.swift
//  100dayChallenge1
//
//  Created by yunus on 02.02.2024.
//

import SwiftUI

struct AuthView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isSignInMode: Bool = true // true для входа, false для регистрации
    @State private var errorMessage: String? = nil

    var body: some View {
        VStack(spacing: 20) {
            Text(isSignInMode ? "Sign In" : "Sign Up")
                .font(.largeTitle)
                .bold()

            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.emailAddress)
                .autocapitalization(.none)

            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.footnote)
                    .padding(.top, 5)
            }

            Button(action: handleAuthAction) {
                Text(isSignInMode ? "Sign In" : "Sign Up")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.top, 10)

            Button(action: { isSignInMode.toggle() }) {
                Text(isSignInMode ? "Don't have an account? Sign Up" : "Already have an account? Sign In")
                    .font(.footnote)
                    .foregroundColor(.blue)
            }

            HorizontalGridView()
        }
        .padding()
    }

    func handleAuthAction() {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "All fields are required."
            return
        }
        // Логика входа/регистрации (вызов API, обработка ошибок и т.д.)
        if isSignInMode {
            // Вызов функции входа
            print("Sign In with email: \(email)")
        } else {
            // Вызов функции регистрации
            print("Sign Up with email: \(email)")
        }
    }
}

struct HorizontalGridView: View {
    let data = Array(1...10)
    let rows = [
        GridItem(.flexible())
    ]

    var body: some View {
        ScrollView(.horizontal) {
            LazyHGrid(rows: rows, spacing: 40) {
                ForEach(data, id: \.self) { item in
                    Button {
                        print("Tapped \(item)")
                    } label: {
                        Text("\(item)")
                            .frame(minWidth: 100, idealWidth: 100, maxWidth: 100, minHeight: 100, idealHeight: 100, maxHeight: 100, alignment: .center)
                            .background(.red)
                    }

                }
            }
            .padding()
        }
    }
}


#Preview {
    AuthView()
}
