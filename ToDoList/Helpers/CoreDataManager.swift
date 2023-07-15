//
//  CoreDataManager.swift
//

import Foundation
import CoreData

class CoreDataManager: DataManager {
    var todoItems: [String: TodoItem] = [:]

    var persistentContainer: NSPersistentContainer
    var context: NSManagedObjectContext

    init() {
        persistentContainer = NSPersistentContainer(name: "Tasks")
        persistentContainer.loadPersistentStores(completionHandler: { (_, error) in
            print(error as Any)
        })
        context = persistentContainer.viewContext
    }

    @discardableResult
    func add(item: TodoItem) -> TodoItem? {
        todoItems.updateValue(item, forKey: item.id)
    }

    @discardableResult
    func remove(forKey key: String) -> TodoItem? {
        todoItems.removeValue(forKey: key)
    }

    func save() {
        do {
            guard let entity = NSEntityDescription.entity(forEntityName: "CoreDataTodoItem", in: context) else {
                return
            }
            todoItems.forEach { (_: String, value: TodoItem) in
                let task = NSManagedObject(entity: entity, insertInto: context)
                task.setValue(value.id, forKey: TodoItem.CodingKeys.id.rawValue)
                task.setValue(value.text, forKey: TodoItem.CodingKeys.text.rawValue)
                task.setValue(value.creationDate, forKey: TodoItem.CodingKeys.creationDate.rawValue)
                task.setValue(value.deadline, forKey: TodoItem.CodingKeys.deadline.rawValue)
                task.setValue(value.changeDate, forKey: TodoItem.CodingKeys.changeDate.rawValue)
                task.setValue(value.done, forKey: TodoItem.CodingKeys.done.rawValue)
                task.setValue(value.importance.rawValue, forKey: TodoItem.CodingKeys.importance.rawValue)
                task.setValue(value.color, forKey: TodoItem.CodingKeys.color.rawValue)
                task.setValue(value.lastUpdatedBy, forKey: TodoItem.CodingKeys.lastUpdatedBy.rawValue)
            }
            try context.save()
        } catch {
            print(error)
        }
    }

    func load() {
        do {
            let items = try context.fetch(CoreDataTodoItem.fetchRequest())
            items.compactMap({ TodoItem.parse(from: $0) }).forEach({ add(item: $0) })
        } catch {
            print(error)
        }
    }

    func insert(item: TodoItem) {
        add(item: item)
        guard let entity = NSEntityDescription.entity(forEntityName: "CoreDataTodoItem", in: context) else {
            return
        }

        do {
            let task = NSManagedObject(entity: entity, insertInto: context)
            task.setValue(item.id, forKey: TodoItem.CodingKeys.id.rawValue)
            task.setValue(item.text, forKey: TodoItem.CodingKeys.text.rawValue)
            task.setValue(item.creationDate, forKey: TodoItem.CodingKeys.creationDate.rawValue)
            task.setValue(item.deadline, forKey: TodoItem.CodingKeys.deadline.rawValue)
            task.setValue(item.changeDate, forKey: TodoItem.CodingKeys.changeDate.rawValue)
            task.setValue(item.done, forKey: TodoItem.CodingKeys.done.rawValue)
            task.setValue(item.importance.rawValue, forKey: TodoItem.CodingKeys.importance.rawValue)
            task.setValue(item.color, forKey: TodoItem.CodingKeys.color.rawValue)
            task.setValue(item.lastUpdatedBy, forKey: TodoItem.CodingKeys.lastUpdatedBy.rawValue)
            try context.save()
        } catch {
            print(error)
        }
    }

    func update(item: TodoItem) {
        add(item: item)
        do {
            let request = NSFetchRequest<CoreDataTodoItem>(entityName: "CoreDataTodoItem")
            request.predicate = NSPredicate(format: "id = %@", item.id)
            let task = try context.fetch(request).first
            task?.setValue(item.text, forKey: TodoItem.CodingKeys.text.rawValue)
            task?.setValue(item.deadline, forKey: TodoItem.CodingKeys.deadline.rawValue)
            task?.setValue(item.changeDate, forKey: TodoItem.CodingKeys.changeDate.rawValue)
            task?.setValue(item.done, forKey: TodoItem.CodingKeys.done.rawValue)
            task?.setValue(item.importance.rawValue, forKey: TodoItem.CodingKeys.importance.rawValue)
            task?.setValue(item.color, forKey: TodoItem.CodingKeys.color.rawValue)
            task?.setValue(item.lastUpdatedBy, forKey: TodoItem.CodingKeys.lastUpdatedBy.rawValue)
            try context.save()
        } catch {
            print(error)
        }
    }

    func delete(with id: String) {
        remove(forKey: id)
        do {
            let request = NSFetchRequest<CoreDataTodoItem>(entityName: "CoreDataTodoItem")
            request.predicate = NSPredicate(format: "id = %@", id)
            guard let task = try context.fetch(request).first else {
                return
            }
            context.delete(task)
            try context.save()
        } catch {
            print(error)
        }
    }
}
