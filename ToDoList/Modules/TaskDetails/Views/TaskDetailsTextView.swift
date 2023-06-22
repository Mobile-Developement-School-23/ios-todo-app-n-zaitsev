//
//  TaskDetailsTextView.swift
//

import UIKit

class TaskDetailsTextView: UITextView {

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setupView()
        textContainer?.heightTracksTextView = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var textViewDidChange: ((String) -> ())?

    let minimumHeight: CGFloat = 120

    override func resignFirstResponder() -> Bool {
        if text.isEmpty {
            text = L10n.TaskDetails.TextView.placeholder
        }
        return super.resignFirstResponder()
    }

    func set(text: String) {
        guard !text.isEmpty else {
            self.text = L10n.TaskDetails.TextView.placeholder
            return
        }
        self.text = text
    }

    // MARK: -private
    private var heightConstraint: NSLayoutConstraint?

    private func setupView() {
        text = L10n.TaskDetails.TextView.placeholder
        layer.cornerRadius = 16
        textContainerInset = .init(top: 16, left: 16, bottom: 12, right: 16)
        delegate = self
        isScrollEnabled = false
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(greaterThanOrEqualToConstant: minimumHeight).isActive = true
    }
}

extension TaskDetailsTextView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        textViewDidChange?(textView.text)
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == L10n.TaskDetails.TextView.placeholder {
            textView.text = ""
        }
    }
}
