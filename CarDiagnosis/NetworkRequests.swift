//
//  NetworkRequests.swift
//  CarDiagnosis
//
//  Created by Allen Roman on 4/17/24.
//


import Foundation

struct ChatResponse: Decodable {
    let response: String
}

enum APIServiceError: Error {
    case responseError(String)
    case parsingError(String)
    case networkError(String)
}

class APIService {
    let baseURL = "http://ec2-18-188-115-9.us-east-2.compute.amazonaws.com:8000" // Replace with your actual base URL
    
    func getChat(question: String, completion: @escaping (Result<String, APIServiceError>) -> Void) {
        let endpoint = "/getChatbot"
        performRequest(endpoint: endpoint, headers: ["question": question], completion: completion)
    }
    
    func customChat(question: String, carIssue: String, carDetails: String, carDiagnosis: String, completion: @escaping (Result<String, APIServiceError>) -> Void) {
        let endpoint = "/customChat"
        let headers = [
            "question": question,
            "carIssue": carIssue,
            "carDetails": carDetails,
            "carDiagnosis": carDiagnosis
        ]
        performRequest(endpoint: endpoint, headers: headers, completion: completion)
    }
    
    func getDiagnosis(carIssue: String, carDetails: String, completion: @escaping (Result<String, APIServiceError>) -> Void) {
        let endpoint = "/getDiagnosis"
        let headers = [
            "carIssue": carIssue,
            "carDetails": carDetails
        ]
        performRequest(endpoint: endpoint, headers: headers, completion: completion)
    }
    
    func getParts(carIssue: String, carDetails: String, carDiagnosis: String, completion: @escaping (Result<String, APIServiceError>) -> Void) {
        let endpoint = "/getParts"
        let headers = [
            "carIssue": carIssue,
            "carDetails": carDetails,
            "carDiagnosis": carDiagnosis
        ]
        performRequestParts(endpoint: endpoint, headers: headers, completion: completion)
    }

    
    func getMechanics(longitude: Double, latitude: Double, completion: @escaping (Result<String, APIServiceError>) -> Void) {
        let endpoint = "/getMech"
        let headers = [
            "longitude": String(longitude),
            "latitude": String(latitude)
        ]
        performRequest(endpoint: endpoint, headers: headers, completion: completion)
    }
    
    private func performRequest(endpoint: String, headers: [String: String], completion: @escaping (Result<String, APIServiceError>) -> Void) {
        guard let url = URL(string: baseURL + endpoint) else {
            completion(.failure(.networkError("Invalid URL")))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        headers.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.networkError(error.localizedDescription)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                completion(.failure(.responseError("Unexpected response status code")))
                return
            }
            
            guard let mimeType = httpResponse.mimeType, mimeType == "application/json", let data = data else {
                completion(.failure(.responseError("Invalid data or MIME type")))
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(ChatResponse.self, from: data)
                completion(.success(decodedResponse.response))
            } catch {
                completion(.failure(.parsingError("Failed to decode response")))
            }
        }
        task.resume()
    }
    
    
    func performRequestParts(endpoint: String, headers: [String: String], completion: @escaping (Result<String, APIServiceError>) -> Void) {
        guard let url = URL(string: baseURL + endpoint) else {
            completion(.failure(.networkError("Invalid URL")))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        headers.forEach { request.setValue($1, forHTTPHeaderField: $0) } // Set headers, if necessary
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion(.failure(.networkError(error?.localizedDescription ?? "Unknown network error")))
                return
            }
            
            if let responseString = String(data: data, encoding: .utf8) {
                completion(.success(responseString))
            } else {
                completion(.failure(.parsingError("Failed to decode response into string")))
            }
        }
        task.resume()
    }


}

struct PartsResponse: Decodable {
    let response: String
}

