//
//  FinalPage.swift
//  CarDiagnosis
//
//  Created by Allen Roman on 4/15/24.
//

import Foundation
import SwiftUI


// view for final diagnosis page
struct FinalPage: View {
    @Binding public var carDiagnosis: String
    @Binding public var carIssue: String
    @Binding public var carDetails: String
    
    @State public var showChatbot = false
    @State public var showParts = false
    @State public var showDealers = false
    
    var body: some View {
        ZStack{
            MainBackgroundColor()
            VStack{
                // shows the diagnosis of the cars issues
                Text("The Diagnosis")
                    .underline()
                    .foregroundColor(.white)
                    .bold()
                BubbleBox(text: carDiagnosis)
                
                // go to page for chat bot
                MainButton(title: "Ask more details"){
                    showChatbot = true
                }
                .sheet(isPresented: $showChatbot){
                    DiagnosisChatView(carIssues: $carIssue, carDetails: $carDetails, carDiagnosis: $carDiagnosis)
                }
                
                // go to page for finding parts
                MainButton(title: "Find Parts"){
                    showParts = true
                }
                .sheet(isPresented: $showParts){
                    FindParts()
                }
                
                // go to page for finding dealers
                MainButton(title: "Find Dealers"){
                    showDealers = true
                }
                .sheet(isPresented: $showDealers){
                    FindDealers()
                }
            }
        }
    }
}


struct BubbleBox: View {
    @State public var text: String
    var body: some View {
        Text(text)
            .font(.system(.body, design: .monospaced)) // Using a monospaced font
            .padding()  // Add padding inside the bubble
            .background(Color.white) // Set the background color of the bubble to white
            .foregroundColor(.black) // Set the text color to black
            .cornerRadius(15) // Round the corners of the bubble
            .shadow(radius: 3) // Optional: add a shadow for a 3D effect
            .padding() // Add space around the bubble
    }
}

//#Preview{
//    @State var s1 = "Car Issue"
//    @State var s2 = "Car Details"
//    @State var s3 = "Car Diagnosis"
//    
//    FinalPage(carDiagnosis: $s3, carIssue: $s2, carDetails: $s1)
//}
