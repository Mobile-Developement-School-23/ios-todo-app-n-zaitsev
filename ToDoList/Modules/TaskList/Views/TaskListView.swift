//
//  TaskListView.swift
//

import UIKit

final class TaskListView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        tableView.dataSource = dataSource
        tableView.register(TaskListInfoView.self, forHeaderFooterViewReuseIdentifier: TaskListInfoView.className)
        tableView.register(TaskDetailsTableViewCell.self, forCellReuseIdentifier: TaskDetailsTableViewCell.className)
        tableView.separatorInset = .init(top: 0, left: 52, bottom: 0, right: 0)
        addButton.addTarget(self, action: #selector(onAddButtonTap), for: .touchUpInside)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    weak var delegate: TaskListViewDelegate?
    
    func setup(with items: [TaskDetailsCellModel]) {
        snapshot.deleteAllItems()
        snapshot.appendSections([.main])
        snapshot.appendItems(items, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: true)
    }

    func setTableViewDelegate(_ delegate: UITableViewDelegate) {
        tableView.delegate = delegate
    }

    enum TaskListSection: Hashable {
        case main
    }
    
    private lazy var dataSource: DataSource = makeDataSource()
    private lazy var tableView = UITableView(frame: .zero, style: .insetGrouped)
    private lazy var addButton = TaskListAddButton()
    private var snapshot = Snapshot()

    private func makeDataSource() -> DataSource {
        DataSource(tableView: tableView) { [weak self] tableView, indexPath, item in
            guard let self else {
                return UITableViewCell()
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: TaskDetailsTableViewCell.className, for: indexPath) as? TaskDetailsTableViewCell
            cell?.configure(with: item)
            cell?.onRadioButtonTap = { [weak self, weak tableView] in
                guard let self else {
                    return
                }
                let view = tableView?.headerView(forSection: 0) as? TaskListInfoView
                let count = self.delegate?.onRadionButtonTap(item: item, expanded: view?.expanded ?? true)
                view?.configure(with: count ?? 0 , expanded: view?.expanded ?? true)
            }
            return cell
        }
    }

    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
        tableView.backgroundColor = .clear
        tableView.layer.cornerRadius = 16
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
    
    private typealias DataSource = UITableViewDiffableDataSource<TaskListSection, TaskDetailsCellModel>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<TaskListSection, TaskDetailsCellModel>

    @objc
    private func onAddButtonTap() {
        delegate?.onAddButtonTap()
    }
}
