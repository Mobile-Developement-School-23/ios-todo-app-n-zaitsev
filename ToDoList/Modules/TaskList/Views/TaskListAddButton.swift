//
//  TaskListAddButton.swift
//

import UIKit

final class TaskListAddButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 22
        backgroundColor = Assets.Colors.Color.blue.color
        setImage(Assets.Assets.Icons.plus.image, for: .normal)
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: 44).isActive = true
        widthAnchor.constraint(equalToConstant: 44).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
