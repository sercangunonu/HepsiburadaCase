//
//  NetworkManager.swift
//  HepsiburadaCase
//
//  Created by Sercan Deniz on 5.03.2024.
//

import Foundation

enum DataError: Error {
    case invalidData
    case invalidResponse
    case message(_ error: Error?)
}

public class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}

    func fetchData<T: Codable>(with url: URL, completion: @escaping (Result<T, DataError>) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data else {
                completion(.failure(.invalidData))
                return
            }
            guard let response = response as? HTTPURLResponse, 199 ... 299  ~= response.statusCode else {
                completion(.failure(.invalidResponse))
                return
            }
            
            do {
                let questions = try JSONDecoder().decode(T.self, from: data)
                completion(.success(questions))
            }
            catch {
                completion(.failure(.message(error)))
            }
        }.resume()
    }
}
