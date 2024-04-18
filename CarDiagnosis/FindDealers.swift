//
//  FindDealers.swift
//  CarDiagnosis
//
//  Created by Allen Roman on 4/15/24.
//

import SwiftUI
import MapKit

struct FindDealers: View {
    @State private var dealers: String = "Dealers: Loading..."

    var body: some View {
        ZStack {
            MainBackgroundColor()
            VStack {
                BubbleBox(text: $dealers)
            }
        }
        .onAppear {
            //fetchParts()
            searchForPlaces(withQuery: "auto repair") { mapItems, error in
                if let error = error {
                    print("Error searching for places: \(error.localizedDescription)")
                    return
                }
                
                guard let mapItems = mapItems else {
                    print("No places found.")
                    return
                }
                
                // Limit to the first 10 items or the count of available items, whichever is smaller
                let count = min(mapItems.count, 6)
                
                dealers = "Dealers: \n\n"
                for i in 0..<count {
                    let item = mapItems[i]
                    let name = item.name ?? "Unknown"
                    let address = getAddress(from: item.placemark)
                    print("Name: \(name), Address: \(address)")
                    dealers = dealers + "Name: \(name)\nAddress: \(address)\n\n"
                }
            }

        }
    }

//    private func fetchParts() {
//        APIService().getMechanics(longitude: 34.04, latitude: -84.046){ result in
//            DispatchQueue.main.async {
//                switch result {
//                case .success(let mechanics):
//                    self.dealers = "Dealers:\n\(mechanics)"
//                    print("API Success: \(self.dealers)")
//                case .failure(let error):
//                    self.dealers = "Failed to fetch dealers: \(error.localizedDescription)"
//                    print("API Error: \(self.dealers)")
//                }
//            }
//        }
//    }
}

// Define a function to perform a local search
func searchForPlaces(withQuery query: String, completion: @escaping ([MKMapItem]?, Error?) -> Void) {
    let request = MKLocalSearch.Request()
    request.naturalLanguageQuery = query
    
    let search = MKLocalSearch(request: request)
    search.start { response, error in
        guard let response = response else {
            completion(nil, error)
            return
        }
        
        completion(response.mapItems, nil)
    }
}

func getAddress(from placemark: MKPlacemark) -> String {
    var addressComponents: [String] = []
    
    // Add street address if available
    if let street = placemark.thoroughfare {
        addressComponents.append(street)
    }
    
    // Add locality (city) if available
    if let city = placemark.locality {
        addressComponents.append(city)
    }
    
    // Add administrative area (state) if available
    if let state = placemark.administrativeArea {
        addressComponents.append(state)
    }
    
    // Add postal code if available
    if let postalCode = placemark.postalCode {
        addressComponents.append(postalCode)
    }
    
    // Concatenate address components into a single string
    return addressComponents.joined(separator: ", ")
}

#Preview{
    FindDealers()
}
