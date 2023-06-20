//
//  TextDetailsDeleteButton.swift
//

import UIKit

class TextDetailsDeleteButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = Assets.Colors.Back.secondary.color
        setTitleColor(Assets.Colors.Label.disable.color, for: .normal)
        setTitle(L10n.TaskDetails.DeleteButton.delete, for: .normal)
        layer.cornerRadius = 16
    }

    func setEnable(_ isEnable: Bool) {
        let color = isEnable ? Assets.Colors.Color.red.color : Assets.Colors.Label.disable.color
        setTitleColor(color, for: .normal)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
