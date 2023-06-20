//
//  FileCache.swift
//

import Foundation

enum FileCacheError: Error {
    case unsupportableData
    case emptyFile
}

final class FileCache {
    private(set) var todoItems: [String: TodoItem] = [:]

    enum Format: String {
        case json
        case csv
    }

    func add(item: TodoItem) {
        todoItems.updateValue(item, forKey: item.id)
    }

    func remove(forKey key: String) {
        todoItems.removeValue(forKey: key)
    }

    func save(to filename: String, format: Format) throws {
        let path = try getPath(of: filename, format: format)
        switch format {
        case .json:
            let data = try JSONSerialization.data(withJSONObject: todoItems.map({ $1.json }))
            try data.write(to: path, options: [.atomic])
        case .csv:
            var csvString = TodoItem.csvHeader
            csvString += todoItems.map({ $1.csv }).joined(separator: "\n")
            try csvString.write(to: path, atomically: true, encoding: .utf8)
        }
    }

    func load(from filename: String, format: Format) throws {
        let path = try getPath(of: filename, format: format)
        switch format {
        case .json:
            let data = try Data(contentsOf: path)
            guard let json = try JSONSerialization.jsonObject(with: data) as? [Any] else {
                throw FileCacheError.unsupportableData
            }
            let result = json.compactMap({ TodoItem.parse(json: $0) })
            result.forEach({ self.add(item: $0) })
            return
        case .csv:
            var data = try String(contentsOf: path).components(separatedBy: "\n")
            guard !data.isEmpty else {
                throw FileCacheError.emptyFile
            }
            _ = data.removeFirst()
            let result = data.compactMap({ TodoItem.parse(csv: $0) })
            result.forEach({ self.add(item: $0) })
            return
        }
    }

    private func getPath(of filename: String, format: Format) throws -> URL {
        try FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appending(path: "\(filename).\(format)")
    }
}
