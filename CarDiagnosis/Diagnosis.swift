//
//  Diagnosis.swift
//  CarDiagnosis
//
//  Created by Allen Roman on 4/15/24.
//

import SwiftUI

struct DiagnosisView: View {
    @State private var carIssues: String = ""
    @State private var carDetails: String = ""
    @State private var carDiagnosis: String = ""
    
    @State private var showFinalPage = false
    
    var body: some View {
        ZStack {
            MainBackgroundColor()
            VStack {
                Text("Car Brand, Model and Year")
                    .foregroundColor(.white)
                    .bold()
                TextBox(userInput: $carDetails)
                    .padding(.bottom, 30)
                
                Text("Automobile Symptoms (aka what's wrong)")
                    .foregroundColor(.white)
                    .bold()
                TextBox(userInput: $carIssues)
                    .padding(.bottom, 30)
                
                MainButton(title: "Diagnose Issue") {
                    fetchDiagnosis(carDetails: carDetails, carIssue: carIssues) { diagnosis in
                        DispatchQueue.main.async {
                            carDiagnosis = diagnosis
                            showFinalPage = true
                            print("Car details: \(carDetails)")
                            print("Car Issues: \(carIssues)")
                            print("Car Diagnosis: \(carDiagnosis)")
                        }
                    }
                }
                .fullScreenCover(isPresented: $showFinalPage) {
                    FinalPage(carDiagnosis: $carDiagnosis, carIssue: $carIssues, carDetails: $carDetails)
                }
            }
        }
    }
}

func fetchDiagnosis(carDetails: String, carIssue: String, completion: @escaping (String) -> Void) {
    let apiService = APIService()
    apiService.getDiagnosis(carIssue: carIssue, carDetails: carDetails) { result in
        switch result {
        case .success(let diagnosis):
            completion(diagnosis)  // Pass the diagnosis to the completion handler
        case .failure(let error):
            completion("Failed to fetch diagnosis: \(error.localizedDescription)")  // Pass the error message
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


#Preview {
    DiagnosisView()
}
