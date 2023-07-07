//
//  URLSession+dataTaskAsync.swift
//

import Foundation

extension URLSession {
    func dataTask(for urlRequest: URLRequest) async throws -> (Data, URLResponse) {
             return try await withCheckedThrowingContinuation({ continuation in
                 let task = self.dataTask(with: urlRequest) { data, response, error in
                     if let error = error {
                         continuation.resume(throwing: error)
                     }

                     guard let data = data, let response = response else {
                         return
                     }
                     DispatchQueue.main.async {
                         continuation.resume(returning: (data, response))
                     }
                 }

                 if Task.isCancelled {
                     task.cancel()
                 } else {
                     task.resume()
                 }
             })
         }
}
