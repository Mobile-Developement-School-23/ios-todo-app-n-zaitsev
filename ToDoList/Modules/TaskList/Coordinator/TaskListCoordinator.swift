//
//  TaskListCoordinator.swift
//

import UIKit
import CocoaLumberjackSwift
import FileCache

final class TaskListCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []

    unowned let navigationController: UINavigationController
    let fileCache: FileCache

    required init(navigationController: UINavigationController) {
        fileCache = FileCache()
        self.navigationController = navigationController
    }
    public let fileLogger: DDFileLogger = DDFileLogger()
    private let filename = "test"
    private let format =  FileCache.Format.json
    func start() {
        setupLogger()
        do {
            try fileCache.load(from: filename, format: format)
            DDLogInfo("Load from file \(filename + format.rawValue) succeded")
        } catch let error {
            DDLogError(error.localizedDescription)
        }
        let items = Array(fileCache.todoItems.values)
        let taskListVC = TaskListViewController(items: items)
        taskListVC.onDetailsViewController = { [weak self, weak taskListVC] item, state, animated in
            guard let self else {
                return
            }
            self.onDetailsViewController(item: item, state: state, animated: animated, from: taskListVC)
        }
        taskListVC.onDeleteItem = { [weak self, weak taskListVC] item in
            self?.delete(item: item, viewController: taskListVC)
        }
        taskListVC.saveNewItem = { [weak self, weak fileCache] item in
            guard let self else {
                return
            }
            _ = fileCache?.add(item: item)
            do {
                try fileCache?.save(to: self.filename, format: self.format)
                DDLogInfo("Save to file \(self.filename + self.format.rawValue) succeded")
            } catch let error {
                DDLogError(error.localizedDescription)
            }
        }
        navigationController.pushViewController(taskListVC, animated: true)
    }

    private func setupLogger() {
        DDLog.add(DDOSLogger.sharedInstance)
        fileLogger.rollingFrequency = TimeInterval(60*60*24)
        fileLogger.logFileManager.maximumNumberOfLogFiles = 7
        DDLog.add(fileLogger, with: .info)
    }
}

extension TaskListCoordinator {
    func delete(item: TodoItem, viewController: TaskListViewController?) {
        fileCache.remove(forKey: item.id)
        do {
            try fileCache.save(to: filename, format: format)
            DDLogInfo("Save to file \(filename + format.rawValue) succeded")
        } catch let error {
            DDLogError(error.localizedDescription)
        }
        viewController?.update(with: .init(item: item), action: .remove)
    }

    func onDetailsViewController(
        item: TodoItem,
        state: TaskDetailsState,
        animated: Bool,
        from viewControler: TaskListViewController?
    ) {
        let taskDetailsVC = TaskDetailsViewController(item: item, state: state)
        let navigationController = UINavigationController(rootViewController: taskDetailsVC)
        if animated {
            navigationController.modalPresentationStyle = .custom
            navigationController.transitioningDelegate = viewControler
        } else {
            navigationController.modalPresentationStyle = .popover
        }
        taskDetailsVC.onCancelButton = { [weak navigationController] in
            navigationController?.dismiss(animated: true)
        }
        taskDetailsVC.onSaveButton = { [weak self, weak navigationController, weak viewControler] item in
            guard let self else {
                return
            }
            let oldItem = self.fileCache.add(item: item)
            let action: TaskListTableViewActions = oldItem != nil ? .update : .add
            do {
                try self.fileCache.save(to: self.filename, format: self.format)
                DDLogInfo("Save to file \(self.filename + self.format.rawValue) succeded")
            } catch let error {
                DDLogError(error.localizedDescription)
            }
            viewControler?.update(with: .init(item: item), action: action)
            navigationController?.dismiss(animated: true)
        }
        taskDetailsVC.onDeleteButton = { [weak navigationController, weak viewControler, weak self] item in
            self?.delete(item: item, viewController: viewControler)
            navigationController?.dismiss(animated: true)
        }
        self.navigationController.present(navigationController, animated: true)
    }
}
