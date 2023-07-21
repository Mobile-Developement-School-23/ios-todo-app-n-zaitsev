//
//  TaskListViewModel.swift
//

import Foundation
import Combine

final class TaskListViewModel: ObservableObject {
    @Published var headerModel: InfoHeaderModel
    @Published var listModel: ListModel
    @Published var hidden: Bool

    private var cancellableHeader: AnyCancellable?
    private var cancellableCount: AnyCancellable?

    init(headerModel: InfoHeaderModel, listModel: ListModel, hidden: Bool) {
        self.headerModel = headerModel
        self.listModel = listModel
        self.hidden = hidden
        self.cancellableHeader = headerModel.objectWillChange.sink(receiveValue: { _ in
            self.objectWillChange.send()
        })
        self.cancellableCount = listModel.objectWillChange.sink(receiveValue: { _ in
            self.objectWillChange.send()
        })
    }
}
