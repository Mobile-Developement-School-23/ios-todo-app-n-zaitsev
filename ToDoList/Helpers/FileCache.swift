//
//  FileCache.swift
//

import Foundation

final class FileCache {
    private var todoItems: [String: TodoItem] = [:]
    
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
        guard let path = try getPath(of: filename, format: format) else {
            return
        }
        switch format {
        case .json:
            let data = try JSONSerialization.data(withJSONObject: todoItems.map({ $1.json }))
            try data.write(to: path, options: [.atomic])
        case .csv:
            var csvString = TodoItem.getHeaderForCSV()
            todoItems.forEach({ csvString.append($1.csv + "\n")})
            try csvString.write(to: path, atomically: true, encoding: .utf8)
        }

    }

    func load(from filename: String, format: Format) throws -> [TodoItem] {
        guard let path = try getPath(of: filename, format: format) else {
            return []
        }
        switch format {
        case .json:
            let data = try Data(contentsOf: path)
            guard let json = try JSONSerialization.jsonObject(with: data) as? [Any] else {
                return []
            }
            return json.compactMap({ TodoItem.parse(json: $0) })
        case .csv:
            return []
        }
    }

    private func getPath(of filename: String, format: Format) throws -> URL? {
        try FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appending(path: "\(filename).\(format)")
    }
}
