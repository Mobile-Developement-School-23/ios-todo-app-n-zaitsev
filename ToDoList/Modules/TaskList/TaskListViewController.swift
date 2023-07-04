//
//  TaskListViewController.swift
//

import UIKit
// swiftlint:disable line_length
final class TaskListViewController: UIViewController {

    init(items: [TodoItem]) {
        self.items = items.map({ .init(item: $0) }).sorted(by: { $0.creationDate < $1.creationDate })
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        super.loadView()
        setupView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        taskListView.setup(with: makeTaskDetailsCells(items: items))
        taskListView.set(expanded: expanded)
        taskListView.delegate = self
        taskListView.setTableViewDelegate(self)
    }

    var onDetailsViewController: ((TodoItem, TaskDetailsState, Bool) -> Void)?
    var onDeleteItem: ((TodoItem) -> Void)?
    var saveNewItem: ((TodoItem) -> Void)?

    func update(with item: TaskListItemModel, action: TaskListTableViewActions) {
        switch action {
        case .add:
            items.append(item)
        case .remove:
            if let index = items.firstIndex(where: { item.id == $0.id }) {
                items.remove(at: index)
            }
        case .update:
            if let index = items.firstIndex(where: { item.id == $0.id }) {
                items.remove(at: index)
                items.insert(item, at: index)
            }
        }
        taskListView.set(expanded: expanded)
        if expanded {
            taskListView.setup(with: makeTaskDetailsCells(items: items))
        } else {
            taskListView.setup(with: makeTaskDetailsCells(items: items.filter({ !$0.done })))
        }
    }

    private var items: [TaskListItemModel] = []
    private var expanded: Bool = true {
        didSet {
            taskListView.set(expanded: expanded)
        }
    }

    private lazy var taskListView = TaskListView()

    private func makeTaskDetailsCells(items: [TaskListItemModel]) -> [TaskListRow] {
        var raws: [TaskListRow] = items.map({ .details((TaskDetailsCellModel(item: $0))) })
        if !self.items.isEmpty {
            raws += [.create]
        }
        return raws
    }

    private func makeTaskInfoCells(items: [TaskListItemModel]) -> Int {
        items.reduce(into: 0) { $0 += $1.done ? 1 : 0 }
    }

    private func setupView() {
        title = L10n.TaskList.title
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.layoutMargins.left = 32

        view.backgroundColor = Assets.Colors.Back.backPrimary.color

        view.addSubview(taskListView)
        NSLayoutConstraint.activate([
            taskListView.topAnchor.constraint(equalTo: view.topAnchor),
            taskListView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            taskListView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            taskListView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    let transition = NicePresentAnimationController()
}

extension TaskListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == tableView.numberOfRows(inSection: 0) - 1 {
            onDetailsViewController?(.init(), .create, false)
        } else {
            let cell = tableView.cellForRow(at: indexPath) as? TaskDetailsTableViewCell
            cell?.onDetails?(true)
        }
        tableView.deselectRow(at: indexPath, animated: false)
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard !items.isEmpty,
              let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: TaskListInfoView.className) as? TaskListInfoView
        else { return nil }
        view.configure(with: makeTaskInfoCells(items: items), expanded: expanded)
        view.tapOnShowLabel = { [weak self, weak taskListView, weak view] expanded in
            guard let self, let taskListView else {
                return
            }
            if !expanded {
                taskListView.setup(with: makeTaskDetailsCells(items: self.items))
            } else {
                taskListView.setup(with: makeTaskDetailsCells(items: self.items.filter({ !$0.done })))
            }
            let count = self.items.filter({ $0.done }).count
            self.expanded = !expanded
            view?.configure(with: count, expanded: !expanded)
        }
        return view
    }

    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let doneAction = UIContextualAction(style: .normal, title: nil) { (_, _, completion) in
            let cell = tableView.cellForRow(at: indexPath) as? TaskDetailsTableViewCell
            cell?.onRadioButtonTap?()
            completion(true)
        }
        doneAction.backgroundColor = Assets.Colors.Color.green.color
        doneAction.image = Assets.Assets.Icons.done.image

        let swipeConfiguration = UISwipeActionsConfiguration(actions: [doneAction])
        return swipeConfiguration
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let onInfoAction = UIContextualAction(style: .normal, title: nil) { (_, _, completion) in
            let cell = tableView.cellForRow(at: indexPath) as? TaskDetailsTableViewCell
            cell?.onDetails?(false)
            completion(true)
        }
        onInfoAction.backgroundColor = Assets.Colors.Color.gray.color
        onInfoAction.image = Assets.Assets.Icons.info.image

        let deleteAction = UIContextualAction(style: .normal, title: nil) { [weak self] (_, _, completion) in
            guard let self else {
                return
            }
            let cell = tableView.cellForRow(at: indexPath) as? TaskDetailsTableViewCell
            cell?.onDelete?()
            let view = tableView.headerView(forSection: 0) as? TaskListInfoView
            let count = self.items.filter({ $0.done }).count
            view?.configure(with: count, expanded: self.expanded)
            completion(true)
        }
        deleteAction.backgroundColor = Assets.Colors.Color.red.color
        deleteAction.image = Assets.Assets.Icons.delete.image

        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction, onInfoAction])
        return swipeConfiguration
    }

    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        guard let cell = tableView.cellForRow(at: indexPath) as? TaskDetailsTableViewCell else {
            return nil
        }
        return UIContextMenuConfiguration(identifier: indexPath as NSIndexPath, previewProvider: nil) { [weak cell] _ in
            let doneAction = UIAction(
                title: L10n.TaskList.ContextMenu.Done.title,
                image: Assets.Assets.Icons.done.image.withTintColor(Assets.Colors.Color.green.color)
            ) { [weak cell] _ in
                cell?.onRadioButtonTap?()
            }

            let editAction = UIAction(
                title: L10n.TaskList.ContextMenu.Edit.title,
                image: Assets.Assets.Icons.info.image.withTintColor(Assets.Colors.Color.gray.color)
            ) { [weak cell] _ in
                cell?.onDetails?(false)
            }
            let deleteAction = UIAction(
                title: L10n.TaskList.ContextMenu.Delete.title,
                image: Assets.Assets.Icons.delete.image.withTintColor(Assets.Colors.Color.red.color),
                attributes: .destructive
            ) { [weak cell] _ in
                cell?.onDelete?()
            }
            return UIMenu(children: [doneAction, editAction, deleteAction])
        }
    }

    func tableView(_ tableView: UITableView, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {
        guard let indexPath = configuration.identifier as? IndexPath else {
            return
        }

        let cell = tableView.cellForRow(at: indexPath) as? TaskDetailsTableViewCell
        animator.addCompletion { [weak cell] in
            cell?.onDetails?(true)
        }
    }
}

extension TaskListViewController: TaskListViewDelegate {
    func onRadionButtonTap(id: String, expanded: Bool) -> Int {
        guard let index = items.firstIndex(where: { $0.id == id }) else {
            return items.filter({ $0.done }).count
        }
        items[index].done.toggle()
        items[index].changeDate = Date()
        if expanded {
            taskListView.setup(with: makeTaskDetailsCells(items: items))
        } else {
            taskListView.setup(with: makeTaskDetailsCells(items: items.filter({ !$0.done })))
        }
        saveNewItem?(items[index].toItem())
        return items.filter({ $0.done }).count
    }

    func onAddButtonTap() {
        onDetailsViewController?(.init(), .create, false)
    }

    func onDelete(id: String) -> Int {
        guard let item = items.first(where: { $0.id == id }) else {
            return 0
        }
        onDeleteItem?(item.toItem())
        return items.filter({ $0.done }).count
    }

    func onDetails(id: String, state: TaskDetailsState, animated: Bool) {
        guard let item = items.first(where: { $0.id == id }) else {
            return
        }
        onDetailsViewController?(item.toItem(), state, animated)
    }
}

extension TaskListViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard
            let selectedIndexPathCell = taskListView.tableView.indexPathForSelectedRow,
            let selectedCell = taskListView.tableView.cellForRow(at: selectedIndexPathCell) as? TaskDetailsTableViewCell,
            let selectedCellSuperview = selectedCell.superview
          else {
            return nil
        }
        transition.originFrame = selectedCellSuperview.convert(selectedCell.frame, to: nil)
        return transition
    }
}
// swiftlint:enable line_length
