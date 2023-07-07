//
//  DefaultNetworkService.swift
//

import Foundation

// swiftlint:disable all
class DefaultNetworkService: NetworkService {
    func produceRequest<Request: DataRequest>(_ request: Request, completion: @escaping (Result<Request.Response, Error>) -> Void) async {
        guard var urlComponent = URLComponents(string: request.url) else {
            DispatchQueue.main.async {
                completion(.failure(NSError(domain: ErrorResponse.invalidEndpoint.rawValue, code: 404)))
            }
            return
        }

        var queryItems: [URLQueryItem] = []

        request.queryItems.forEach { queryItems.append(URLQueryItem(name: $0.key, value: $0.value)) }

        urlComponent.queryItems = queryItems

        guard let url = urlComponent.url else {
            DispatchQueue.main.async {
                completion(.failure(NSError(domain: ErrorResponse.invalidEndpoint.rawValue, code: 404)))
            }
            return
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.allHTTPHeaderFields = request.headers
        if let body = request.body, (request.method == .post || request.method == .put || request.method == .patch) {
            let encoder = JSONEncoder()
            urlRequest.httpBody = try? encoder.encode(body)
        }

        do {
            let (data, response) = try await URLSession.shared.dataTask(for: urlRequest)
            guard let response = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    completion(.failure(NSError(domain: ErrorResponse.invalidEndpoint.description, code: 404)))
                }
                return
            }

            guard 200..<300 ~= response.statusCode else {
                DispatchQueue.main.async {
                    switch response.statusCode {
                    case 400:
                        completion(.failure(NSError(domain: ErrorResponse.requestError.description, code: 400)))
                    case 401:
                        completion(.failure(NSError(domain: ErrorResponse.authorizationError.description, code: 401)))
                    case 404:
                        completion(.failure(NSError(domain: ErrorResponse.elementNoFound.description, code: 404)))
                    default:
                        completion(.failure(NSError(domain: ErrorResponse.serverError.description, code: 500)))
                    }
                }
                return
            }

            let success = try request.decode(data)
            DispatchQueue.main.async {
                completion(.success(success))
            }
        } catch (let error) {
            DispatchQueue.main.async {
                completion(.failure(error))
            }
        }
    }
}
// swiftlint:enable all
