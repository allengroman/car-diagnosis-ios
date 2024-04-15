//
//  Diagnosis.swift
//  CarDiagnosis
//
//  Created by Allen Roman on 4/15/24.
//

import SwiftUI


struct DiagnosisView: View{
    @State private var carIssues: String = ""
    @State private var carDetails: String = ""
    @State private var carDiagnosis: String = ""
    
    @State private var showFinalPage = false
    
    var body: some View{
        ZStack{
            MainBackgroundColor()
            VStack{
                Text("Car Brand, Model and Year")
                    .foregroundColor(.white)
                    .bold()
                TextBox(userInput: $carDetails)
                    .padding(.bottom, 30)
                
                
                Text("Automobile Symptoms (aka whats wrong)")
                    .foregroundColor(.white)
                    .bold()
                TextBox(userInput: $carIssues)
                    .padding(.bottom, 30)
                
                MainButton(title: "Diagnose Issue"){
                    carDiagnosis = getDiagnosis(carIssues: carIssues, carDetails: carDetails)
                    print("Car details: ", carDetails)
                    print("Car Issues: ", carIssues)
                    print("Car Diagnosis", carDiagnosis)
                    showFinalPage = true
                }
                .fullScreenCover(isPresented: $showFinalPage) {
                    FinalPage(carDiagnosis: $carDiagnosis, carIssue: $carIssues, carDetails: $carDetails)
                }
                
            }
        }
    }
}


// view for text boxes
struct TextBox: View {
    @Binding var userInput: String  // Changed from @State to @Binding

    var body: some View {
        TextField("Enter details", text: $userInput)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()
    }
}

// function that inputs car details and issues and outputs diagnosis
func getDiagnosis(carIssues: String, carDetails: String) -> String {
    var finalPrompt: String = """
    Car Details: \(carDetails)
    Car Symptoms:\(carIssues)
    
    Use this information to curate the most probable issue with the car.
    Give a short but detailed diagnosis on what is wrong with the automobile.
    """
    
    // call api here
    
    return "\(carDetails) is having issues with \(carIssues)"
}

#Preview {
    DiagnosisView()
}
