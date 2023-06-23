//
//  TaskDetailsViewController.swift
//

import UIKit

class TaskDetailsViewController: UIViewController {
    
    init(item: TodoItem, fileCache: FileCache) {
        self.model = .init(item: item)
        self.fileCache = fileCache
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
        taskView.setDeleteButton(enable: false)
        addGestureRecognizerToHideKeyboard()
        setupObservers()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        taskView.setup(text: model.text, color: model.color, importance: model.importance, deadline: model.deadline)
        taskView.detailsViewDelegate = self
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

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
    private let fileCache: FileCache

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
            taskView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }

    func setupObservers() {
        NotificationCenter.default
            .addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default
            .addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    private func addGestureRecognizerToHideKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        taskView.addGestureRecognizer(tap)
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
        fileCache.add(item: newItem)
        try? fileCache.save(to: "test", format: .json)
        dismiss(animated: true)
    }
    
    @objc
    private func dismissKeyboard() {
        taskView.endEditing(true)
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

extension TaskDetailsViewController: TaskDetailsViewProtocol {
    func textViewDidChange(text: String) {
        model.text = text
        updateButtonsIfNeeded()
    }

    func deleteButtonDidTap() {
        fileCache.remove(forKey: model.item.id)
        dismiss(animated: true)
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

    func colorDidChange(newColor: UIColor) {
        model.color = newColor
        updateButtonsIfNeeded()
    }
}
