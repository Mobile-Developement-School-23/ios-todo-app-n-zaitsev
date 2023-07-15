//
//  TaskListViewController.swift
//

import UIKit
// swiftlint:disable line_length
final class TaskListViewController: UIViewController {

    init(networkService: TaskListNetworkServiceProtocol) {
        self.networkService = networkService
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
        taskListView.delegate = self
        taskListView.setTableViewDelegate(self)
        activityIndicator.startAnimating()
        networkService.getTaskList { [weak self] result in
            guard let self else {
                return
            }
            switch result {
            case .success(let data):
                self.items = data.list.map({ .init(item: $0) })
                self.revision = data.revision
                self.saveItemsFromNetwork?(data.list)
                self.taskListView.setup(with: self.makeTaskDetailsCells(items: self.items), count: self.items.filter({ $0.done }).count)
                self.taskListView.set(expanded: self.expanded)
                self.activityIndicator.stopAnimating()
            case .failure(let error):
                print(error.localizedDescription)
                guard let items = self.loadItemsFromFile?() else {
                    return
                }
                self.isDirty = true
                self.items = items.map({ .init(item: $0) })
                self.taskListView.setup(with: self.makeTaskDetailsCells(items: self.items), count: self.items.filter({ $0.done }).count)
                self.taskListView.set(expanded: self.expanded)
                self.activityIndicator.stopAnimating()
            }
        }
    }

    let transition = NicePresentAnimationController()
    let networkService: TaskListNetworkServiceProtocol

    var onDetailsViewController: ((TodoItem, TaskDetailsState, Bool) -> Void)?
    var deleteItemFromFile: ((TodoItem) -> Void)?
    var saveNewItemToFile: ((TodoItem) -> Void)?
    var loadItemsFromFile: (() -> [TodoItem])?
    var updateItem: ((TodoItem) -> Void)?
    var saveItemsFromNetwork: (([TodoItem]) -> Void)?

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
        let count = items.filter({ $0.done }).count
        if expanded {
            taskListView.setup(with: makeTaskDetailsCells(items: items), count: count)
        } else {
            taskListView.setup(with: makeTaskDetailsCells(items: items.filter({ !$0.done })), count: count)
        }
    }

    func setup(revision: Int32) {
        self.revision = revision
    }

    func setup(isDirty: Bool) {
        self.isDirty = isDirty
        syncModel(completion: nil)
    }

    private(set) var revision: Int32 = 0
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    private var items: [TaskListItemModel] = []
    private var isDirty: Bool = false

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

        let barButton = UIBarButtonItem(customView: activityIndicator)
        self.navigationItem.setRightBarButton(barButton, animated: true)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
    }
}

// MARK: - TaskListViewController+UITableViewDelegate
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
        view.tapOnShowLabel = { [weak self, weak taskListView] expanded in
            guard let self, let taskListView else {
                return
            }
            let count = self.items.filter({ $0.done }).count
            taskListView.set(expanded: !expanded)
            if !expanded {
                taskListView.setup(with: makeTaskDetailsCells(items: self.items), count: count)
            } else {
                taskListView.setup(with: makeTaskDetailsCells(items: self.items.filter({ !$0.done })), count: count)
            }
            self.expanded = !expanded
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

        return UISwipeActionsConfiguration(actions: [doneAction])
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let cell = tableView.cellForRow(at: indexPath) as? TaskDetailsTableViewCell else {
            return nil
        }
        let onInfoAction = UIContextualAction(style: .normal, title: nil) { [weak cell] (_, _, completion) in
            cell?.onDetails?(false)
            completion(true)
        }
        onInfoAction.backgroundColor = Assets.Colors.Color.gray.color
        onInfoAction.image = Assets.Assets.Icons.info.image

        let deleteAction = UIContextualAction(style: .normal, title: nil) { [weak cell] (_, _, completion) in
            cell?.onDelete?()
            completion(true)
        }
        deleteAction.backgroundColor = Assets.Colors.Color.red.color
        deleteAction.image = Assets.Assets.Icons.delete.image

        return UISwipeActionsConfiguration(actions: [deleteAction, onInfoAction])
    }

    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        guard let cell = tableView.cellForRow(at: indexPath) as? TaskDetailsTableViewCell else {
            return nil
        }
        return UIContextMenuConfiguration(identifier: indexPath as NSIndexPath, previewProvider: nil) { [weak cell] _ in
            let doneAction = UIAction(
                title: L10n.TaskList.ContextMenu.Done.title,
                image: Assets.Assets.Icons.done.image.withTintColor(Assets.Colors.Color.green.color)
            ) { [weak cell] _ in cell?.onRadioButtonTap?() }

            let editAction = UIAction(
                title: L10n.TaskList.ContextMenu.Edit.title,
                image: Assets.Assets.Icons.info.image.withTintColor(Assets.Colors.Color.gray.color)
            ) { [weak cell] _ in cell?.onDetails?(false) }

            let deleteAction = UIAction(
                title: L10n.TaskList.ContextMenu.Delete.title,
                image: Assets.Assets.Icons.delete.image.withTintColor(Assets.Colors.Color.red.color),
                attributes: .destructive
            ) { [weak cell] _ in cell?.onDelete?() }
            return UIMenu(children: [doneAction, editAction, deleteAction])
        }
    }

    func tableView(_ tableView: UITableView, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {
        guard let indexPath = configuration.identifier as? IndexPath else {
            return
        }

        let cell = tableView.cellForRow(at: indexPath) as? TaskDetailsTableViewCell
        animator.addCompletion { [weak cell] in cell?.onDetails?(true) }
    }
}

// MARK: - TaskListViewController+TaskListViewDelegate
extension TaskListViewController: TaskListViewDelegate {
    func onRadionButtonTap(id: String, expanded: Bool) {
        guard let index = items.firstIndex(where: { $0.id == id }) else {
            return
        }
        items[index].done.toggle()
        items[index].changeDate = Date.now
        change(item: items[index].toItem())
    }

    func onAddButtonTap() {
        onDetailsViewController?(.init(), .create, false)
    }

    func onDelete(id: String) {
        delete(with: id)
    }

    func onDetails(id: String, state: TaskDetailsState, animated: Bool) {
        guard let item = items.first(where: { $0.id == id }) else {
            return
        }
        onDetailsViewController?(item.toItem(), state, animated)
    }
}

// MARK: - TaskListViewController+UIViewControllerTransitioningDelegate
extension TaskListViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard
            let selectedIndexPathCell = taskListView.tableView.indexPathForSelectedRow,
            let selectedCell = taskListView.tableView.cellForRow(at: selectedIndexPathCell) as? TaskDetailsTableViewCell,
            let selectedCellSuperview = selectedCell.superview
          else { return nil }
        transition.originFrame = selectedCellSuperview.convert(selectedCell.frame, to: nil)
        return transition
    }
}
// swiftlint:enable line_length

// MARK: - TaskListViewController+Network
extension TaskListViewController {
    private func syncModel(completion: (() -> Void)?) {
        guard isDirty else {
            completion?()
            return
        }
        networkService.updateTaskList(items.map({ $0.toItem() }), revision: revision) { [weak self] result in
            guard let self else {
                return
            }
            switch result {
            case .success(let data):
                self.items = data.list.map({ .init(item: $0) })
                self.revision = data.revision
                self.isDirty = false
                let count = self.items.filter({ $0.done }).count
                self.taskListView.setup(with: self.makeTaskDetailsCells(items: self.items), count: count)
            case .failure(let error):
                print(error.localizedDescription)
            }
            completion?()
        }
    }

    private func change(item: TodoItem) {
        syncModel { [weak self] in
            guard let self else {
                return
            }
            if !activityIndicator.isAnimating {
                activityIndicator.startAnimating()
            }
            networkService.changeItem(item, revision: revision) { [weak self] result in
                guard let self else {
                    return
                }
                switch result {
                case .success(let data):
                    revision = data.revision
                    updateItem?(data.element)
                case .failure(let error):
                    print(error.localizedDescription)
                    updateItem?(item)
                    isDirty = true
                }
                let count = items.filter({ $0.done }).count
                if expanded {
                    taskListView.setup(with: makeTaskDetailsCells(items: items), count: count)
                } else {
                    taskListView.setup(with: makeTaskDetailsCells(items: items.filter({ !$0.done })), count: count)
                }
                activityIndicator.stopAnimating()
            }
        }
    }

    func delete(with id: String) {
        syncModel { [weak self] in
            guard let self else {
                return
            }
            if !activityIndicator.isAnimating {
                activityIndicator.startAnimating()
            }
            networkService.deleteItem(with: id, revision: revision) { [weak self] result in
                switch result {
                case .success(let data):
                    self?.deleteItemFromFile?(data.element)
                    self?.update(with: .init(item: data.element), action: .remove)
                    self?.activityIndicator.stopAnimating()
                    self?.revision = data.revision
                case .failure(let error):
                    print(error.localizedDescription)
                    guard let item = self?.items.first(where: { $0.id == id }) else {
                        return
                    }
                    self?.isDirty = true
                    self?.update(with: item, action: .remove)
                    self?.activityIndicator.stopAnimating()
                }
            }
        }
    }
}
