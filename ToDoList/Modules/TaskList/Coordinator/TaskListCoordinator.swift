//
//  TaskListCoordinator.swift
//

import UIKit

final class TaskListCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []

    unowned let navigationController: UINavigationController
    let fileCache: SQLManager

    required init(navigationController: UINavigationController) {
        fileCache = SQLManager(file: "items")
        self.navigationController = navigationController
    }

    func start() {
        let networkService = TaskListNetworkService(networkService: DefaultNetworkService())
        let taskListVC = TaskListViewController(networkService: networkService)
        taskListVC.onDetailsViewController = { [weak self, weak taskListVC] item, state, animated in
            guard let self else {
                return
            }
            self.onDetailsViewController(item: item, state: state, animated: animated, from: taskListVC)
        }
        taskListVC.saveItemsFromNetwork = { [weak self] items in
            items.forEach({ self?.fileCache.add(item: $0) })
            self?.fileCache.save()
        }
        taskListVC.deleteItemFromFile = { [weak self] item in
            self?.fileCache.delete(with: item.id)
        }
        taskListVC.updateItem = { [weak self] item in
            self?.fileCache.update(item: item)
        }
        taskListVC.saveNewItemToFile = { [weak fileCache] item in
            fileCache?.insert(item: item)
        }
        taskListVC.loadItemsFromFile = { [weak fileCache] in
            guard let fileCache else {
                return []
            }
            fileCache.load()
            return Array(fileCache.todoItems.values)
        }
        navigationController.pushViewController(taskListVC, animated: true)
    }
}

extension TaskListCoordinator {
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
        taskDetailsVC.onSaveButton = { [weak navController, weak viewController, weak self] item, revision, isDirty in
            let action: TaskListTableViewActions = state == .create ? .add : .update
            if action == .add {
                self?.fileCache.insert(item: item)
            } else {
                self?.fileCache.update(item: item)
            }
            viewController?.update(with: .init(item: item), action: action)
            viewController?.setup(revision: revision)
            viewController?.setup(isDirty: isDirty)
            navController?.dismiss(animated: true)
        }
        taskDetailsVC.onDeleteButton = { [weak navController, weak viewController, weak self] item, revision, isDirty in
            self?.fileCache.delete(with: item.id)
            viewController?.update(with: .init(item: item), action: .remove)
            viewController?.setup(revision: revision)
            viewController?.setup(isDirty: isDirty)
            navController?.dismiss(animated: true)
        }
        taskDetailsVC.loadItemFromFile = {
            return item
        }
        navigationController.present(navController, animated: true)
    }
}
