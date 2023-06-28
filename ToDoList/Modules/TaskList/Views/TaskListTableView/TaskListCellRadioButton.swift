//
//  TaskListCellRadioButton.swift
//

import UIKit

class TaskListCellRadioButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 12
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let biggerButtonFrame = frame.insetBy(dx: -16, dy: -16) // 1

        if biggerButtonFrame.contains(point) { // 2
            return self // 3
        }

        return super.hitTest(point, with: event) // 4
    }
}
