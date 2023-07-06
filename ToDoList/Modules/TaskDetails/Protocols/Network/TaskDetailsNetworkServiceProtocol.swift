//
//  TaskDetailsNetworkServiceProtocol.swift
//

import Foundation

protocol TaskDetailsNetworkServiceProtocol: SingleTaskNetworkActionProtocol {
    func getItem(with id: String, completion: @escaping (Result<TaskDetailsResponse, Error>) -> Void)
}
