//
//  TaskListViewModel.swift
//

import Foundation
import Combine

final class ListModel: ObservableObject {
    @Published var items: [TaskCellModel]

    private var cancellables: [AnyCancellable?] = []

    init(items: [TaskCellModel]) {
        self.items = items
        items.forEach { [weak self] model in
            self?.cancellables.append(model.$done.sink { _ in
                self?.objectWillChange.send()
            })
        }
    }
}

final class TaskListViewModel: ObservableObject {
    @Published var headerModel: InfoHeaderModel
    @Published var listModel: ListModel

    private var cancellableHeader: AnyCancellable?
    private var cancellableList: AnyCancellable?
    private var cancellableCount: AnyCancellable?

    init(headerModel: InfoHeaderModel, listModel: ListModel) {
        self.headerModel = headerModel
        self.listModel = listModel
        self.cancellableHeader = headerModel.objectWillChange.sink(receiveValue: { _ in
            self.objectWillChange.send()
        })
        self.cancellableCount = listModel.objectWillChange.sink(receiveValue: { _ in
            self.objectWillChange.send()
        })
    }
}
