//
//  ChatView.swift
//  FlashChat
//
//  Created by Anubhav Chaturvedi on 30/04/25.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct ChatView: View {
    
    let db = Firestore.firestore()
    
    @State private var messageTxt: String = ""
    @State private var messages: [Message] = []
    @State private var isLoggedIn: Bool = true
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .trailing) {
            
                ScrollViewReader { scrollViewProxy in
                    ScrollView(showsIndicators:false) {
                        VStack(alignment: .leading, spacing: 8) {
                            ForEach(messages.indices, id: \.self) { index in
                                let message = messages[index]
                                HStack {
                                    if message.sender == Auth.auth().currentUser?.email {
                                        Spacer()
                                        
                                        HStack(spacing: 8) {
                                            ZStack {
                                                RoundedRectangle(cornerRadius: 15)
                                                    .foregroundStyle(.brandPurple)
                                                Text(message.body)
                                                    .foregroundColor(.white)
                                                    .padding(.horizontal, 12)
                                                    .padding(.vertical, 8)
                                                    .fixedSize(horizontal: false, vertical: true)
                                            }
                                            .frame(maxWidth: UIScreen.main.bounds.width * 0.6, alignment: .leading)
                                            
                                            Image("MeAvatar")
                                                .resizable()
                                                .frame(width: 30, height: 30)
                                                .clipShape(Circle())
                                        }
                                    } else {
                                        HStack(spacing: 8) {
                                            Image("YouAvatar")
                                                .resizable()
                                                .frame(width: 30, height: 30)
                                                .clipShape(Circle())
                                            
                                            ZStack {
                                                RoundedRectangle(cornerRadius: 15)
                                                    .foregroundStyle(.brandLightPurple)
                                                Text(message.body)
                                                    .foregroundColor(.brandPurple)
                                                    .padding(.horizontal, 12)
                                                    .padding(.vertical, 8)
                                                    .fixedSize(horizontal: false, vertical: true)
                                            }
                                            .frame(maxWidth: UIScreen.main.bounds.width * 0.6, alignment: .leading)
                                        }
                                        Spacer()
                                    }
                                }
                                .padding(.horizontal)
                                .id(index) // 👈 Add ID for scrolling
                            }
                        }
                        .padding(.top)
                    }
                    .onChange(of: messages.count) { oldCount, newCount in
                        withAnimation {
                            scrollViewProxy.scrollTo(newCount - 1, anchor: .bottom)
                        }
                    }
                }
                
                ZStack {
                    Rectangle()
                        .ignoresSafeArea()
                        .foregroundStyle(.brandPurple)
                        .frame(width:geometry.size.width, height:70)
                    
                    
                    HStack {
                        TextField("Write a message...", text: $messageTxt)
                            .textFieldStyle(.roundedBorder)
                        
                        Button {
                            //Add Message to Firebase
                            messagetoFirebase()
                            messageTxt = ""
                        } label: {
                            Image(systemName: "paperplane.fill")
                                .foregroundStyle(.brandLightBlue)
                                .font(.system(size: 30))
                        }
                    }.padding(.horizontal, 10)
                }
            }
        }
        
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("⚡️FlashChat")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.purple)
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button(action: {
                                    logout()
                                }) {
                                    Text("LOG OUT") // Or use Text("Add")
                                }
                            }
                        }
        .onAppear() {
            Task {
                await fetchMessages()
            }
        }
    }
    
    func logout() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            dismiss()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    func messagetoFirebase() {
        if let messageSender = Auth.auth().currentUser?.email {
            db.collection("messages").addDocument(data:["sender": messageSender,"body":messageTxt,"date":Date().timeIntervalSince1970]) { (error) in
                if let e = error {
                    print("Error adding document: \(e)")
                } else {
                    print("Successfully saved data!")
                }
            }
        }
    }
    
    func fetchMessages() async {
        
        db.collection("messages")
            .order(by: "date")
            .addSnapshotListener  { (querySnapshot, error) in
                
                self.messages = []
                
                if let e = error {
                    print("There was an error fetching data: \(e)")
                } else {
                    if let snapshotDocuments = querySnapshot?.documents {
                        for doc in snapshotDocuments {
                            let data = doc.data()
                            if let messageSender = data["sender"] as? String, let messagerBody = data["body"] as? String {
                                let newMessage = Message(sender: messageSender, body: messagerBody)
                                
                                self.messages.append(newMessage)
                                
                            }
                        }
                    }
                }
            }
    }
}
#Preview {
    ChatView()
}
