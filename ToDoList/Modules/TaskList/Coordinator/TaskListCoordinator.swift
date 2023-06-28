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
        taskListVC.onDetailsViewController = { [weak self] item, state, animated in
            guard let self else {
                return
            }
            let taskDetailsVC = TaskDetailsViewController(item: item, state: state)
            let nc = UINavigationController(rootViewController: taskDetailsVC)
            if animated {
                nc.modalPresentationStyle = .custom
                nc.transitioningDelegate = taskListVC
            } else {
                nc.modalPresentationStyle = .popover
            }
            taskDetailsVC.onCancelButton = { [weak taskDetailsVC] in
                taskDetailsVC?.dismiss(animated: true)
            }
            taskDetailsVC.onSaveButton = { [weak taskDetailsVC, weak taskListVC, weak self] item in
                let oldItem = self?.fc.add(item: item)
                let action: TaskListTableViewActions = oldItem != nil ? .update : .add
                try? self?.fc.save(to: "test", format: .json)
                taskListVC?.update(with: .init(item: item), action: action)
                taskDetailsVC?.dismiss(animated: true)
            }
            taskDetailsVC.onDeleteButton = { [weak taskDetailsVC, weak taskListVC, weak self] item in
                self?.fc.remove(forKey: item.id)
                try? self?.fc.save(to: "test", format: .json)
                taskListVC?.update(with: .init(item: item), action: .remove)
                taskDetailsVC?.dismiss(animated: true)
            }
            self.navigationController.present(nc, animated: true)
        }
        navigationController.pushViewController(taskListVC, animated: true)
    }
}
