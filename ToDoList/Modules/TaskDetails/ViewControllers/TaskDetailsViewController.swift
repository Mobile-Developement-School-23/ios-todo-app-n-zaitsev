//
//  TaskDetailsViewController.swift
//

import UIKit

final class TaskDetailsViewController: UIViewController {
    init(id: String, revision: Int32, networkService: TaskDetailsNetworkService, state: TaskDetailsState) {
        self.networkService = networkService
        self.state = state
        self.id = id
        self.revision = revision
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
        if state == .update {
            networkService.getItem(with: id) { [weak self] result in
                guard let self else {
                    return
                }
                switch result {
                case .success(let data):
                    self.model = .init(item: data.element)
                case .failure(let error):
                    break
                }
            }
        } else {
            self.model = .init(item: .init())
        }
        taskView.detailsViewDelegate = self
    }

    let networkService: TaskDetailsNetworkService
    var onCancelButton: (() -> Void)?
    var onSaveButton: ((TodoItem, Int32) -> Void)?
    var onDeleteButton: ((TodoItem, Int32) -> Void)?

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
    private let id: String
    private let revision: Int32
    private let state: TaskDetailsState
    private var model: TaskDetailsModel? {
        didSet {
            guard let model else {
                return
            }
            DispatchQueue.main.async { [weak self] in
                self?.taskView.setup(text: model.text,
                                     color: model.color,
                                     importance: model.importance,
                                     deadline: model.deadline)
                self?.updateButtonsIfNeeded()
            }

        }
    }

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
    private func setupObservers() {
        NotificationCenter.default
            .addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default
            .addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    // swiftlint:enable line_length

    private func updateButtonsIfNeeded() {
        guard let model else {
            return
        }
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
        guard let model else {
            return
        }
        switch state {
        case .create:
            networkService.addItem(model.getNewItem(), revision: revision) { [weak self] result in
                switch result {
                case .success(let data):
                    DispatchQueue.main.async {
                        self?.onSaveButton?(data.element, data.revision)
                    }
                case .failure(let error):
                    break
                }
            }
        case .update:
            networkService.changeItem(model.getNewItem(), revision: revision) { [weak self] result in
                switch result {
                case .success(let data):
                    DispatchQueue.main.async {
                        self?.onSaveButton?(data.element, data.revision)
                    }
                case .failure(let error):
                    break
                }
            }
        }
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
        model?.text = text
        updateButtonsIfNeeded()
    }

    func deleteButtonDidTap() {
        guard let model else {
            return
        }
        networkService.deleteItem(with: model.item.id, revision: revision) { [weak self] result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self?.onDeleteButton?(data.element, data.revision)
                }
            case .failure(let failure):
                break
            }
        }
    }

    func deadlineDidChange(switchIsOn: Bool, newDeadline: Date?) {
        guard let model else {
            return
        }
        model.changeDeadline(newDeadline: newDeadline, deadlineIsNeeded: switchIsOn)
        taskView.update(deadline: model.deadline)
        updateButtonsIfNeeded()
    }

    func importanceValueDidChange(segment: Int) {
        switch segment {
        case 0:
            model?.importance = .low
        case 2:
            model?.importance = .important
        default:
            model?.importance = .basic
        }
        updateButtonsIfNeeded()
    }

    func colorDidChange(newColor: UIColor?) {
        model?.color = newColor
        updateButtonsIfNeeded()
    }
}
