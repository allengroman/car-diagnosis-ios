//
//  ChatBot.swift
//  CarDiagnosis
//
//  Created by Allen Roman on 4/15/24.
//

import SwiftUI

struct Message: Identifiable {
    let id = UUID()
    let content: String
    let isFromUser: Bool
}

struct ChatView: View {
    @State private var userInput: String = ""
    @State private var messages: [Message] = []
    private let apiService = APIService() // Instance of your API service

    var body: some View {
        ZStack {
            VStack {
                List(messages) { message in
                    HStack {
                        if message.isFromUser {
                            Spacer()
                            Text(message.content)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        } else {
                            Text(message.content)
                                .padding()
                                .background(Color.gray)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                            Spacer()
                        }
                    }
                }
                
                HStack {
                    TextField("Type your message here", text: $userInput)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    Button("Send") {
                        sendMessage()
                    }
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
            }
            .navigationBarTitle("ChatBot")
        }
    }

    func sendMessage() {
        guard !userInput.isEmpty else { return }
        messages.append(Message(content: userInput, isFromUser: true))
        callAPI(with: userInput)
        userInput = ""
    }

    func callAPI(with query: String) {
        apiService.getChat(question: query) { result in
            print(query)
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self.receiveMessage(response)
                case .failure(let error):
                    self.receiveMessage("Error: \(error.localizedDescription)")
                }
            }
        }
    }

    func receiveMessage(_ text: String) {
        messages.append(Message(content: text, isFromUser: false))
    }
}




#Preview {
    ChatView()
}
