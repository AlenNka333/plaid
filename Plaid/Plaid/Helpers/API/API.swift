//
//  API.swift
//  Plaid
//
//  Created by Alena Nesterkina on 23.04.22.
//

import Foundation

class API {
    func requestData(url: URL, parameters: [String: Any], completion: @escaping((Result<Data?, Error>) -> Void)) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
            completion(.failure(error))
            return
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Post Request Error: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }

            completion(.success(data))
        }
        task.resume()
    }
}
