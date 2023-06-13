//
//  FileCache.swift
//

import Foundation

final class FileCache {
    private var todoItems: [String: TodoItem] = [:]
    
    func add(item: TodoItem) {
        todoItems.updateValue(item, forKey: item.id)
    }

    func remove(forKey key: String) {
        todoItems.removeValue(forKey: key)
    }

    func save(to filename: String) throws {
        guard let path = try getPath(of: filename) else {
            return
        }
        let data = try JSONSerialization.data(withJSONObject: todoItems.map({ $1.json }))
        try data.write(to: path, options: [.atomic])
    }

    func loadJSON(from filename: String) throws -> Any? {
        guard let path = try getPath(of: filename) else {
            return nil
        }
        let data = try Data(contentsOf: path)
        let json = try JSONSerialization.jsonObject(with: data)
        return json
    }

    private func getPath(of filename: String) throws -> URL? {
        try FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appending(path: "\(filename).json")
    }
}
