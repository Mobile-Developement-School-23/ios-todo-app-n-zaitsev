//
//  NetworkService.swift
//

import Foundation

protocol NetworkService {
    // swiftlint:disable:next line_length
    func produceRequest<Request: DataRequest>(_ request: Request, completion: @escaping (Result<Request.Response, Error>) -> Void) async
}
