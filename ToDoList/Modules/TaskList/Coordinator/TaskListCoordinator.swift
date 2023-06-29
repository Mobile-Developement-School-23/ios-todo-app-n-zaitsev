//
//  TaskListCoordinator.swift
//

import UIKit

final class TaskListCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []

    unowned let navigationController: UINavigationController
    let fileCache: FileCache

    required init(navigationController: UINavigationController) {
        fileCache = FileCache()
        self.navigationController = navigationController
    }

    func start() {
        try? fileCache.load(from: "test", format: .json)
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
        taskListVC.saveNewItem = { [weak fileCache] item in
            _ = fileCache?.add(item: item)
            try? fileCache?.save(to: "test", format: .json)
        }
        navigationController.pushViewController(taskListVC, animated: true)
    }
}

extension TaskListCoordinator {
    func delete(item: TodoItem, viewController: TaskListViewController?) {
        fileCache.remove(forKey: item.id)
        try? fileCache.save(to: "test", format: .json)
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
        taskDetailsVC.onSaveButton = { [weak navigationController, weak viewControler, weak self] item in
            let oldItem = self?.fileCache.add(item: item)
            let action: TaskListTableViewActions = oldItem != nil ? .update : .add
            try? self?.fileCache.save(to: "test", format: .json)
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
