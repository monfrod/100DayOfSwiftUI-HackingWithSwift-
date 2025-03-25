//
//  listEvents.swift
//  100dayChallenge1
//
//  Created by yunus on 19.01.2025.
//
import SwiftUI

struct MainView: View {
    
    @State var shouldViewFilm: Bool = true
    
    var body: some View {
        NavigationView{
            Text("asdasda")
                .toolbar {
                    ToolbarItemGroup(placement: .principal) {
                        HStack(spacing: 60){
                            Button("Films") {
                                print("Go to Films")
                            }
                            Button("Music") {
                                print("Go to Music")
                            }
                        }
                    }
                }
        }
    }
}

#Preview {
    MainView()
}
