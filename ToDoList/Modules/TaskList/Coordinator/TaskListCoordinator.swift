//
//  TaskListCoordinator.swift
//

import UIKit

final class TaskListCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
        
    unowned let navigationController: UINavigationController
    let fc: FileCache

    required init(navigationController: UINavigationController) {
        fc = FileCache()
        self.navigationController = navigationController
    }
    
    func start() {
        try? fc.load(from: "test", format: .json)
        let items = Array(fc.todoItems.values)
        let taskListVC = TaskListViewController(items: items)
        taskListVC.onDetailsViewController = { [weak self, weak taskListVC] item, state, animated in
            guard let self else {
                return
            }
            self.onDetailsViewController(item: item, state: state, animated: animated, from: taskListVC)
        }
        taskListVC.onDeleteItem = { [weak self, weak taskListVC] item in
            self?.delete(item: item, vc: taskListVC)
        }
        taskListVC.saveNewItem = { [weak fc] item in
            _ = fc?.add(item: item)
            try? fc?.save(to: "test", format: .json)
        }
        navigationController.pushViewController(taskListVC, animated: true)
    }
}

extension TaskListCoordinator {
    func delete(item: TodoItem, vc: TaskListViewController?) {
        fc.remove(forKey: item.id)
        try? fc.save(to: "test", format: .json)
        vc?.update(with: .init(item: item), action: .remove)
    }

    func onDetailsViewController(item: TodoItem, state: TaskDetailsState, animated: Bool, from vc: TaskListViewController?) {
        let taskDetailsVC = TaskDetailsViewController(item: item, state: state)
        let nc = UINavigationController(rootViewController: taskDetailsVC)
        if animated {
            nc.modalPresentationStyle = .custom
            nc.transitioningDelegate = vc
        } else {
            nc.modalPresentationStyle = .popover
        }
        taskDetailsVC.onCancelButton = { [weak nc] in
            nc?.dismiss(animated: true)
        }
        taskDetailsVC.onSaveButton = { [weak nc, weak vc, weak self] item in
            let oldItem = self?.fc.add(item: item)
            let action: TaskListTableViewActions = oldItem != nil ? .update : .add
            try? self?.fc.save(to: "test", format: .json)
            vc?.update(with: .init(item: item), action: action)
            nc?.dismiss(animated: true)
        }
        taskDetailsVC.onDeleteButton = { [weak nc, weak vc, weak self] item in
            self?.delete(item: item, vc: vc)
            nc?.dismiss(animated: true)
        }
        self.navigationController.present(nc, animated: true)
    }
}
