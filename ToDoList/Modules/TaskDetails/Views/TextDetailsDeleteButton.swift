//
//  TextDetailsDeleteButton.swift
//

import UIKit

class TextDetailsDeleteButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = Assets.Colors.Back.secondary.color
        setTitle(L10n.TaskDetails.DeleteButton.delete, for: .normal)
        setTitleColor(Assets.Colors.Color.red.color, for: .normal)
        setTitleColor(Assets.Colors.Label.disable.color, for: .highlighted)
        layer.cornerRadius = 16
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
