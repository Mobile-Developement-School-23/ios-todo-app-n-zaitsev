//
//  TaskListView.swift
//

import UIKit

final class TaskListView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        tableView.dataSource = makeDataSource()
        setupView()
        tableView.register(TaskDetailsTableViewCell.self, forCellReuseIdentifier: TaskDetailsTableViewCell.className)
        tableView.register(TaskListInfoTableViewCell.self, forCellReuseIdentifier: TaskListInfoTableViewCell.className)
        tableView.separatorInset = .init(top: 0, left: 52, bottom: 0, right: 0)
        addButton.addTarget(self, action: #selector(onAddButtonTap), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    weak var delegate: TaskListViewDelegate?
    
    func setup(with items: [TaskListRow], count: TaskListRow) {
        snapshot.appendSections([.info, .main])
        snapshot.appendItems([count], toSection: .info)
        snapshot.appendItems(items, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func update(items: [TaskListRow], count: TaskListRow, action: TaskListTableViewActions) {
        switch action {
        case .add:
            snapshot.appendItems(items, toSection: .main)
        case .remove:
            snapshot.deleteItems(items)
        case .update:
            snapshot.reloadItems(items)
        }
        snapshot.reloadItems([count])
        dataSource.apply(snapshot, animatingDifferences: true)
    }

    func setTableViewDelegate(_ delegate: UITableViewDelegate) {
        tableView.delegate = delegate
    }

    enum TaskListSection: Hashable {
        case info
        case main
    }

    enum TaskListRow: Hashable {
        case info(Int)
        case details(TaskDetailsCellModel)
    }
    
    private lazy var dataSource: DataSource = makeDataSource()
    private lazy var tableView = TaskListTableView(frame: .zero, style: .insetGrouped)
    private lazy var addButton = TaskListAddButton()
    private var snapshot = Snapshot()

    private func makeDataSource() -> DataSource {
        DataSource(tableView: tableView) { tableView, indexPath, item in
            switch item {
            case .info(let count):
                let cell = tableView.dequeueReusableCell(withIdentifier: TaskListInfoTableViewCell.className, for: indexPath) as? TaskListInfoTableViewCell
                cell?.configure(with: count)
                return cell
            case .details(let model):
                let cell = tableView.dequeueReusableCell(withIdentifier: TaskDetailsTableViewCell.className, for: indexPath) as? TaskDetailsTableViewCell
                cell?.configure(with: model)
                return cell
            }
        }
    }

    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
        tableView.backgroundColor = .clear
        addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
        addSubview(addButton)
        NSLayoutConstraint.activate([
            addButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            addButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
    private typealias DataSource = UITableViewDiffableDataSource<TaskListSection, TaskListRow>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<TaskListSection, TaskListRow>

    @objc
    private func onAddButtonTap() {
        delegate?.onAddButtonTap()
    }
}
