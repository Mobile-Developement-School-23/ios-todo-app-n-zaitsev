//
//  DataRequest.swift
//

import Foundation

protocol DataRequest {
    associatedtype Response

    var url: String { get }
    var method: HTTPMethod { get }
    var queryItems: [String: String] { get set }
    var headers: [String: String] { get set }
    var body: [String: Any] { get set }
    
    func decode(_ data: Data) throws -> Response
}
