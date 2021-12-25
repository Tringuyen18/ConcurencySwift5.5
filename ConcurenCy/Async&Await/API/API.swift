//
//  API.swift
//  API
//
//  Created by Nguyễn Trí on 28/08/2021.
//

import Foundation
import UIKit

// MARK: - Completion Handle
func fetchAPI<T: Decodable>(url: URL, completion: @escaping (Result<T, Error>) -> ()) {
    URLSession.shared.dataTask(with: url) { (data, response, error) in
        if let error = error {
            completion(.failure(error))
            return
        }
        
        guard let httpResonse = response as? HTTPURLResponse, httpResonse.statusCode == 200, let data = data else {
            completion(.failure(APIError.error("Bad HTTP Response")))
            return
        }
        
        do {
            let decodeData = try JSONDecoder().decode(T.self, from: data)
            completion(.success(decodeData))
        } catch {
            completion(.failure(error))
        }
    }.resume()
}


// MARK: - Extentions
extension URLSession {
    func data(url: URL) async throws -> Data {
        try await withCheckedThrowingContinuation({ c in
            dataTask(with: url) { data, _, error in
                if let error = error {
                    c.resume(throwing: APIError.error(error.localizedDescription))
                } else {
                    if let data = data {
                        c.resume(returning: data)
                    } else {
                        c.resume(throwing: APIError.error("Bad response"))
                    }
                }
            }.resume() // connect
        })
    }
}

// MARK: - Fetch API
func fetchAPI<T: Decodable>(url: URL) async throws -> T {
    let data = try await URLSession.shared.data(url: url)
    let decodeData = try JSONDecoder().decode(T.self, from: data)
    return decodeData
}

// MARK: - Async
func fetchAPIs<T: Decodable>(urls: [URL]) async throws -> [T] {
    try await withThrowingTaskGroup(of: T.self, body: { group in
        
        for url in urls {
            group.async {
                try await fetchAPI(url: url)
            }
        }
        
        var results = [T]()
        for try await result in group {
            results.append(result)
        }
        return results
    })
}


