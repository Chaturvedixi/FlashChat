//
//  LoginView.swift
//  FlashChat
//
//  Created by Anubhav Chaturvedi on 30/04/25.
//

import SwiftUI
import FirebaseAuth

struct LoginView: View {
    
    @State private var email:String = ""
    @State private var password:String = ""
    @State private var isLogin:Bool = false
    @State private var errorMessage = ""

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
                           
                 
                Button(action: {
                    loginUsear()
                }, label: {
                    Text("Login")
                })
                .font(.title)
                .foregroundStyle(.brandBlue)
                
                Text(errorMessage)
                    .foregroundStyle(.red)
            }
            .padding(.horizontal)
            .navigationDestination(isPresented: $isLogin) {
                ChatView()
            }
        }
    }
    func loginUsear() {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                self.errorMessage = error.localizedDescription
            } else {
                self.isLogin = true
                self.errorMessage = ""
            }
        }
    }
}

#Preview {
    LoginView()
}
