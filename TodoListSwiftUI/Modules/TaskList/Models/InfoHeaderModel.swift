//
//  InfoHeaderModel.swift
//

import Foundation

final class InfoHeaderModel: ObservableObject {
    @Published var count: Int
    @Published var hidden: Bool

    init(count: Int) {
        self.count = count
        self.hidden = false
    }
}
