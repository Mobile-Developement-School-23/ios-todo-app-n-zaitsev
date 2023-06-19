//
//  TaskDetailsTextView.swift
//

import UIKit

class TaskDetailsTextView: UITextView {

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        text = L10n.TaskDetails.TextView.placeholder
        layer.cornerRadius = 16
        clipsToBounds = true
        textContainerInset = .init(top: 16, left: 16, bottom: 12, right: 16)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
