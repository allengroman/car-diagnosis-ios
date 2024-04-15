//
//  DiagnosisChatBot.swift
//  CarDiagnosis
//
//  Created by Allen Roman on 4/15/24.
//

import SwiftUI




struct DiagnosisChatView: View {
    @State private var userInput: String = ""
    @State private var messages: [Message] = []
    
    @Binding public var carIssues: String
    @Binding public var carDetails: String
    @Binding public var carDiagnosis: String

    var body: some View {
        ZStack{
            VStack {
                // Messages will be displayed here
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
                
                // User input area
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
        // Append user message to the messages array
        messages.append(Message(content: userInput, isFromUser: true))
        
        // Here, call your API with the userInput, then handle the response
        callAPI(with: userInput)
        
        // Clear the user input field
        userInput = ""
    }

    func callAPI(with query: String) {
        // This is a placeholder function. You'll need to implement API calling logic here
        // For example, using URLSession to fetch data from an API
        // After fetching the data:
        receiveMessage("This is a simulated response from the API for '\(query)'")
    }

    func receiveMessage(_ text: String) {
        // Append the received message to the messages array
        messages.append(Message(content: text, isFromUser: false))
    }
}

