//
//  ContentView.swift
//  CarDiagnosis
//
//  Created by Allen Roman on 4/15/24.
//

import SwiftUI

// starting view for content
struct ContentView: View {
    // variables to toggle sheet to present
    @State private var showDiagnosisView = false
    @State private var showGeneralView = false
    
    var body: some View {
        ZStack {
            // underlying background
            MainBackgroundColor()
            VStack{
                Text("Pick an option")
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    .bold()
                    .foregroundColor(.white)
                    .padding(30)
                
                MainButton(title: "Diagnose my car issues"){
                    // take to view that deals with diagnosis
                    showDiagnosisView = true
                }
                .padding(15)
                .sheet(isPresented: $showDiagnosisView){
                    DiagnosisView()
                }
                
                MainButton(title: "General Car Questions"){
                    // take to view that has chat bot for general questions
                    showGeneralView = true
                }
                .padding(15)
                .sheet(isPresented: $showGeneralView){
                    GeneralView()
                }
            }
            .padding(.all)
        }
    }
}


// view for main background of the app
struct MainBackgroundColor: View {
    var body: some View {
        Color(red: 0.3, green: 0.5, blue: 0.4) // A dark green color
            .edgesIgnoringSafeArea(.all) // This will extend the color to fill the entire screen area
    }
}


// main button for the app
struct MainButton: View {
    var title: String
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.black)
                .cornerRadius(10)
        }
        .padding() // Adds padding around the button
    }
}



// the content previewer
#Preview {
    ContentView()
}
