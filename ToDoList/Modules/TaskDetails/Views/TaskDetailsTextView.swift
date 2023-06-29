//
//  TaskDetailsTextView.swift
//

import UIKit

final class TaskDetailsTextView: UITextView {

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setupView()
        textContainer?.heightTracksTextView = true
        font = Font.body.font
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var textViewDidChange: ((String) -> Void)?

    let minimumHeight: CGFloat = 120

    override func resignFirstResponder() -> Bool {
        if text.isEmpty {
            setupPlaceholder()
        }
        return super.resignFirstResponder()
    }

    override func becomeFirstResponder() -> Bool {
        if text == L10n.TaskDetails.TextView.placeholder {
            text = ""
            textColor = lastColor
        }
        return super.becomeFirstResponder()
    }

    func setup(text: String, with color: UIColor?) {
        guard !text.isEmpty else {
            setupPlaceholder()
            return
        }
        self.text = text
        textColor = color
        lastColor = color
    }

    func update(color: UIColor?) {
        if text != L10n.TaskDetails.TextView.placeholder {
            textColor = color
        }
        lastColor = color
    }

    // MARK: - private
    private var heightConstraint: NSLayoutConstraint?

    private var lastColor: UIColor?

    private func setupView() {
        setupPlaceholder()
        layer.cornerRadius = 16
        textContainerInset = .init(top: 16, left: 16, bottom: 12, right: 16)
        delegate = self
        isScrollEnabled = false
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(greaterThanOrEqualToConstant: minimumHeight).isActive = true
    }

    private func setupPlaceholder() {
        text = L10n.TaskDetails.TextView.placeholder
        textColor = Assets.Colors.Label.tertiary.color
    }
}

extension TaskDetailsTextView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        textViewDidChange?(textView.text)
    }
}
