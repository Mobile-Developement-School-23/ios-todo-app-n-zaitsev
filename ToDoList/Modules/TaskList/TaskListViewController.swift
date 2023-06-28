//
//  TaskListViewController.swift
//

import UIKit

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
        taskListView.delegate = self
        taskListView.setTableViewDelegate(self)
    }

    var onDetailsViewController: ((TodoItem, TaskDetailsState) -> ())?

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
        
        taskListView.setup(with: makeTaskDetailsCells(items: items))
    }

    private var items: [TaskListItemModel] = []

    private lazy var taskListView = TaskListView()

    private func makeTaskDetailsCells(items: [TaskListItemModel]) -> [TaskDetailsCellModel] {
        items.map({ TaskDetailsCellModel(item: $0) })
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
            taskListView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
}

extension TaskListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let item = items[indexPath.row].toItem()
        onDetailsViewController?(item, .update)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: TaskListInfoView.className) as? TaskListInfoView
        view?.configure(with: makeTaskInfoCells(items: items), expanded: true)
        view?.tapOnShowLabel = { [weak self, weak taskListView, weak view] expanded in
            guard let self, let taskListView else {
                return
            }
            if !expanded {
                taskListView.setup(with: makeTaskDetailsCells(items: items))
            } else {
                taskListView.setup(with: makeTaskDetailsCells(items: items.filter({ !$0.done })))
            }
            let count = items.filter({ $0.done }).count
            view?.configure(with: count, expanded: !expanded)
        }
        return view
    }
}

extension TaskListViewController: TaskListViewDelegate {
    func onRadionButtonTap(item: TaskDetailsCellModel, expanded: Bool) -> Int {
        guard let index = items.firstIndex(where: { $0.id == item.id }) else {
            return items.filter({ $0.done }).count
        }
        items[index].done.toggle()
        if expanded {
            taskListView.setup(with: makeTaskDetailsCells(items: items))
        } else {
            taskListView.setup(with: makeTaskDetailsCells(items: items.filter({ !$0.done })))
        }
        return items.filter({ $0.done }).count
    }
    
    func onAddButtonTap() {
        onDetailsViewController?(.init(), .create)
    }
}
