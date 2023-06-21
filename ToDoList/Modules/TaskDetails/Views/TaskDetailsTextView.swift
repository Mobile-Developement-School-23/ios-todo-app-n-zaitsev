//
//  TaskDetailsTextView.swift
//

import UIKit

class TaskDetailsTextView: UITextView {

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        text = L10n.TaskDetails.TextView.placeholder
        layer.cornerRadius = 16
        textContainerInset = .init(top: 16, left: 16, bottom: 12, right: 16)
        delegate = self
        self.heightConstraint = heightAnchor.constraint(equalToConstant: minimumHeight)
        self.heightConstraint?.isActive = true
        isScrollEnabled = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var textViewDidChange: ((String) -> ())?

    let minimumHeight: CGFloat = 120

    func set(text: String) {
        guard !text.isEmpty else {
            self.text = L10n.TaskDetails.TextView.placeholder
            return
        }
        self.text = text
    }

    private var heightConstraint: NSLayoutConstraint?
}

extension TaskDetailsTextView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let newSize = textView.sizeThatFits(CGSize(width: textView.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
        if newSize.height > minimumHeight {
            heightConstraint?.constant = newSize.height
        }
        textViewDidChange?(textView.text)
    }
}
