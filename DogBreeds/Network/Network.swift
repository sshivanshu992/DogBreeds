//
//  Network.swift
//  DogBreeds
//
//  Created by Shivanshu Verma on 20/06/24.
//

import Foundation


let baseURL = "https://dog.ceo/api"

func createURL(endpoint: String) -> URL? {
    return URL(string: "\(baseURL)\(endpoint)")
}

/// Fetches data from the API and decodes it into the specified type.
/// - Parameters:
///   - endpoint: API endpoint
///   - type: Type to decode the data into
///   - completion: Handler for the result
func fetchData<T: Decodable>(endpoint: String, type: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
    guard let url = createURL(endpoint: endpoint) else {
        DispatchQueue.main.async {
            completion(.failure(NSError.customError(domain: .network, description: "Failed to create URL.")))
        }
        return
    }
    
    URLSession.shared.dataTask(with: url) { data, response, error in
        if let error = error {
            DispatchQueue.main.async {
                completion(.failure(error))
            }
            return
        }
        
        guard let data = data else {
            DispatchQueue.main.async {
                completion(.failure(NSError.customError(domain: .data, description: "No response data was returned by the server.")))
            }
            return
        }
        
        do {
            let decodedData = try JSONDecoder().decode(type, from: data)
            DispatchQueue.main.async {
                completion(.success(decodedData))
            }
        } catch {
            DispatchQueue.main.async {
                completion(.failure(error))
            }
        }
    }.resume()
}
