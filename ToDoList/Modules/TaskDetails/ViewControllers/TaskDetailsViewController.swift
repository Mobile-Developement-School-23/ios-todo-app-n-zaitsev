//
//  TaskDetailsViewController.swift
//

import UIKit

class TaskDetailsViewController: UIViewController {
    
    init(item: TodoItem) {
        model = .init(item: item)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        super.loadView()
        isModalInPresentation = true
        setupNavBar()
        setupView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        taskView.set(text: model.text, importance: model.importance, deadline: model.deadline)
        taskView.textViewDidChange = { [weak self] text in
            self?.model.text = text
            self?.updateButtonsIfNeeded()
        }
        taskView.changeDeadline = { [weak self] switchIsOn, newDeadline in
            self?.model.changeDeadline(newDeadline: newDeadline, deadlineIsNeeded: switchIsOn)
            self?.taskView.set(deadline: self?.model.deadline)
            self?.updateButtonsIfNeeded()
        }
        taskView.setDeleteButton(enable: false)
    }

    var saveItem: ((TodoItem) -> ())?

    // MARK: -private

    private lazy var cancelButton = UIBarButtonItem(
        title: L10n.TaskDetails.NavBar.LeftButton.title,
        style: .plain,
        target: self,
        action: #selector(closeScreen)
    )
    
    private lazy var saveButton = UIBarButtonItem(
        title: L10n.TaskDetails.NavBar.RightButton.title,
        style: .done,
        target: self,
        action: #selector(save)
    )

    private lazy var taskView = TaskDetailsView()
    private let model: TaskDetailsModel

    private func setupNavBar() {
        title = L10n.TaskDetails.NavBar.title
        navigationItem.leftBarButtonItem = cancelButton
        saveButton.tintColor = Assets.Colors.Label.tertiary.color
        navigationItem.rightBarButtonItem = saveButton
    }

    private func setupView() {
        view.addSubview(taskView)
        taskView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            taskView.topAnchor.constraint(equalTo: view.topAnchor),
            taskView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            taskView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            taskView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

        ])
    }

    private func updateButtonsIfNeeded() {
        taskView.setDeleteButton(enable: model.modelDidChange)
        saveButton.tintColor = model.modelDidChange ? Assets.Colors.Color.blue.color : Assets.Colors.Label.tertiary.color
        saveButton.isEnabled = model.modelDidChange
    }

    @objc
    private func closeScreen() {
        dismiss(animated: true)
    }

    @objc
    private func save() {
        let newItem = model.getNewItem()
        saveItem?(newItem)
        dismiss(animated: true)
    }
}
