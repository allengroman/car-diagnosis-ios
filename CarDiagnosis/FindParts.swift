//
//  FindParts.swift
//  CarDiagnosis
//
//  Created by Allen Roman on 4/15/24.
//


import SwiftUI

struct FindParts: View {
    @State private var parts: String = "Parts: Loading..."
    @Binding public var carDetails: String
    @Binding public var carIssue: String
    @Binding public var carDiagnosis: String

    var body: some View {
        ZStack {
            MainBackgroundColor()
            VStack {
                BubbleBox(text: $parts)
            }
        }
        .onAppear {
            fetchParts()
        }
    }

    private func fetchParts() {
        APIService().getParts(carIssue: carIssue, carDetails: carDetails, carDiagnosis: carDiagnosis) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let fetchedParts):
                    self.parts = "Parts: \(fetchedParts)"
                    print("API Success: \(self.parts)")
                    self.parts = formatPartsList(from: self.parts)
                case .failure(let error):
                    self.parts = "Failed to fetch parts: \(error.localizedDescription)"
                    print("API Error: \(self.parts)")
                }
            }
        }
    }
}

func formatPartsList(from jsonString: String) -> String {
    let startIndex = 20
    var formattedString = String(jsonString.suffix(from: jsonString.index(jsonString.startIndex, offsetBy: startIndex)))
    formattedString = "Parts: \n[Name-Quanity-EstPrice]\n____________________\n" + formattedString.replacingOccurrences(of: "],[", with: "]----------------------\n[")
    formattedString = formattedString.replacingOccurrences(of: "[", with: " ")
    formattedString = formattedString.replacingOccurrences(of: "]", with: " ")
    formattedString = formattedString.replacingOccurrences(of: "}", with: " ")
    formattedString = formattedString.replacingOccurrences(of: ",", with: "  ")
    return formattedString
}



