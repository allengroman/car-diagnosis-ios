//
//  FindParts.swift
//  CarDiagnosis
//
//  Created by Allen Roman on 4/15/24.
//

import SwiftUI

struct FindParts: View {
    @Binding public var partsList: [String]
    private let apiService = APIService() // Assuming you have an APIService that handles the API calls

    var body: some View {
        ZStack{
            MainBackgroundColor() // Set the main background color
            BubbleBox(text: "")
        }
    }
}


