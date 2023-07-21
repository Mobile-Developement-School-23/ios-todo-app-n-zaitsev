//
//  InfoHeaderModel.swift
//

import Foundation

final class InfoHeaderModel: ObservableObject {
    @Published var hidden: Bool

    init(hidden: Bool) {
        self.hidden = hidden
    }
}
