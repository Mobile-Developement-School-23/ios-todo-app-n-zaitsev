//
//  ListModel.swift
//

import Combine

final class ListModel: ObservableObject {
    @Published var items: [TaskCellModel]
    var count: Int {
        items.filter({ $0.done }).count
    }

    private var cancellables: [AnyCancellable] = []

    init(items: [TaskCellModel]) {
        self.items = items
        items.forEach { [weak self] model in
            self?.cancellables.append(model.$done.sink { _ in
                self?.objectWillChange.send()
            })
        }
    }
}
