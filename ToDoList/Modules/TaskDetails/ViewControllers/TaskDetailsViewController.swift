//
//  TaskDetailsViewController.swift
//

import UIKit

final class TaskDetailsViewController: UIViewController {
    init(item: TodoItem, state: TaskDetailsState) {
        self.model = .init(item: item)
        self.state = state
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        super.loadView()
        setupNavBar()
        setupView()
        addGestureRecognizerToHideKeyboard()
        setupObservers()
        taskView.setDeleteButton(enable: state != .create)
        updateButtonsIfNeeded()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        taskView.setup(text: model.text, color: model.color, importance: model.importance, deadline: model.deadline)
        taskView.detailsViewDelegate = self
    }

    var onCancelButton: (() -> Void)?
    var onSaveButton: ((TodoItem) -> Void)?
    var onDeleteButton: ((TodoItem) -> Void)?

    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    // MARK: - private

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
    private let state: TaskDetailsState

    private func setupNavBar() {
        title = L10n.TaskDetails.NavBar.title
        navigationItem.leftBarButtonItem = cancelButton
        saveButton.tintColor = Assets.Colors.Label.tertiary.color
        navigationItem.rightBarButtonItem = saveButton
    }

    private func setupView() {
        view.backgroundColor = Assets.Colors.Back.backPrimary.color
        view.addSubview(taskView)
        NSLayoutConstraint.activate([
            taskView.topAnchor.constraint(equalTo: view.topAnchor),
            taskView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            taskView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            taskView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    // swiftlint:disable line_length
    func setupObservers() {
        NotificationCenter.default
            .addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default
            .addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    // swiftlint:enable line_length

    private func updateButtonsIfNeeded() {
        if model.modelDidChange {
            saveButton.tintColor = Assets.Colors.Color.blue.color
        } else {
            saveButton.tintColor = Assets.Colors.Label.tertiary.color
        }
        saveButton.isEnabled = model.modelDidChange
    }

    @objc
    private func closeScreen() {
        onCancelButton?()
    }

    @objc
    private func save() {
        let newItem = model.getNewItem()
        onSaveButton?(newItem)
    }

    @objc
    func keyboardWillShow(notification: NSNotification) {
        guard
              let userInfo = notification.userInfo,
              let height = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height
        else { return }

        taskView.contentInset.bottom = height + 16
     }

    @objc
    func keyboardWillHide(notification: NSNotification) {
        taskView.contentInset = .zero
     }
}

extension TaskDetailsViewController: TaskDetailsViewDelegate {

    func textViewDidChange(text: String) {
        model.text = text
        updateButtonsIfNeeded()
    }

    func deleteButtonDidTap() {
        onDeleteButton?(model.item)
    }

    func deadlineDidChange(switchIsOn: Bool, newDeadline: Date?) {
        model.changeDeadline(newDeadline: newDeadline, deadlineIsNeeded: switchIsOn)
        taskView.update(deadline: model.deadline)
        updateButtonsIfNeeded()
    }

    func importanceValueDidChange(segment: Int) {
        switch segment {
        case 0:
            model.importance = .unimportant
        case 2:
            model.importance = .important
        default:
            model.importance = .ordinary
        }
        updateButtonsIfNeeded()
    }

    func colorDidChange(newColor: UIColor?) {
        model.color = newColor
        updateButtonsIfNeeded()
    }
}
