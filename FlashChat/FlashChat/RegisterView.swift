//
//  RegisterView.swift
//  FlashChat
//
//  Created by Anubhav Chaturvedi on 30/04/25.
//

import SwiftUI
import FirebaseAuth


struct RegisterView: View {
    
    @State private var email:String = ""
    @State private var password:String = ""
    @State private var errorMessage = ""
    @State var isRegistered:Bool = false
    
    var body: some View {
        
        ZStack {
            Color.brandLightBlue
                .edgesIgnoringSafeArea(.all)
            VStack {
                
                TextField("Email", text: $email)
                    .padding()
                    .font(.system(size: 20))
                    .background(Color.white)
                    .cornerRadius(8)
                    
                
                SecureField("Password", text: $password)
                    .padding()
                    .font(.system(size: 20))
                    .background(Color.white)
                    .cornerRadius(8)
                    
                
                Button {
                    // Register New User
                    registerUser()
                    
                } label: {
                    Text("Register")
                        .font(.title)
                        .foregroundStyle(.brandBlue)
                }
                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundStyle(.red)
                }
            }
            .padding(.horizontal)
            .navigationDestination(isPresented: $isRegistered) {
                ChatView()
            }
        }
    }
    func registerUser() {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
          if let error = error {
                self.errorMessage = error.localizedDescription
            } else {
                self.isRegistered = true
                self.errorMessage = ""
            }
        }
    }
}
#Preview {
    RegisterView()
}
