//
//  ContentView.swift
//  FlashChat
//
//  Created by Anubhav Chaturvedi on 30/04/25.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        GeometryReader { geometry in
            NavigationStack {
                
                VStack(spacing:0) {
                    Spacer()
                    Text("⚡️FlashChat")
                        .font(.largeTitle)
                        .bold()
                        .foregroundStyle(.brandBlue)
                    
                    Spacer()
                    ZStack {
                        Rectangle()
                            .frame(width: geometry.size.width, height: 50)
                            .foregroundStyle(.brandLightBlue)
                        
                        NavigationLink {
                            RegisterView()
                        } label: {
                            Text("Register")
                                .font(.title)
                                .fontWeight(.semibold)
                                .foregroundStyle(.brandBlue)
                        }
                    }
                    ZStack {
                        Rectangle()
                            .frame(width: geometry.size.width, height: 50)
                            .foregroundStyle(.brandBlue)
                        
                        NavigationLink {
                            LoginView()
                        } label: {
                            Text("Login")
                                .font(.title)
                                .fontWeight(.semibold)
                                .foregroundStyle(.brandLightBlue)
                        }
                    }
                }
                .padding()
            }
        }
    }
}

#Preview {
    ContentView()
}
