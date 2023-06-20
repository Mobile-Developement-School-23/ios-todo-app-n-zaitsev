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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var textViewDidChange: ((String) -> ())?

    func set(text: String) {
        guard !text.isEmpty else {
            self.text = L10n.TaskDetails.TextView.placeholder
            return
        }
        self.text = text
    }
}

extension TaskDetailsTextView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        textViewDidChange?(textView.text)
    }
}
