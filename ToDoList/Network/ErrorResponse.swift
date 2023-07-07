//
//  ErrorResponse.swift
//

import Foundation

enum ErrorResponse: String {
    case authorizationError
    case elementNoFound
    case serverError
    case requestError
    case undefined
    case noData
    case invalidEndpoint

    public var description: String {
        switch self {
        case .authorizationError:
            return "Неверная авторизация"
        case .elementNoFound:
            return "Такого элемента на сервере не найдено"
        case .serverError:
            return "Ошибка сервера"
        case .requestError:
            return "Неправильно сформирован запрос"
        case .undefined:
            return "Неизвестная ошибка"
        case .noData:
            return "Данных нет"
        case .invalidEndpoint:
            return "Какая-то проблема с ответом"
        }
    }
}
