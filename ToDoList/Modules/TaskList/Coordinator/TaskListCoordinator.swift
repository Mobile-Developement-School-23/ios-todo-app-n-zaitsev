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
        let networkService = TaskListNetworkService(networkService: DefaultNetworkService())
        let taskListVC = TaskListViewController(networkService: networkService)
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

    func onDetailsViewController(item: TodoItem,
                                 state: TaskDetailsState,
                                 animated: Bool,
                                 from viewController: TaskListViewController?
    ) {
        guard let viewController else {
            return
        }
        let networkService = TaskDetailsNetworkService(networkService: DefaultNetworkService())
        let taskDetailsVC = TaskDetailsViewController(id: item.id,
                                                      revision: viewController.revision,
                                                      networkService: networkService,
                                                      state: state)
        let navController = UINavigationController(rootViewController: taskDetailsVC)
        if animated {
            navController.modalPresentationStyle = .custom
            navController.transitioningDelegate = viewController
        } else {
            navController.modalPresentationStyle = .popover
        }
        taskDetailsVC.onCancelButton = { [weak navController] in
            navController?.dismiss(animated: true)
        }
        taskDetailsVC.onSaveButton = { [weak navController, weak viewController, weak self] item in
            let oldItem = self?.fileCache.add(item: item)
            let action: TaskListTableViewActions = state == .create ? .add : .update
            try? self?.fileCache.save(to: "test", format: .json)
            viewController?.update(with: .init(item: item), action: action)
            DispatchQueue.main.async {
                navController?.dismiss(animated: true)
            }
        }
        taskDetailsVC.onDeleteButton = { [weak navController, weak viewController, weak self] item in
            self?.delete(item: item, viewController: viewController)
            navController?.dismiss(animated: true)
        }
        self.navigationController.present(navController, animated: true)
    }
}
