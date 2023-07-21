//
//  TaskList7View.swift
//

import SwiftUI
import Combine

struct TaskListView: View {
    // TODO: change value
    @ObservedObject
    var model: TaskListViewModel

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                Assets.Colors.Back.backPrimary.swiftUIColor.ignoresSafeArea()
                List {
                    Section {
                        ForEach(makeData(), id: \.id) { item in
                            makeItemCell(from: item)
                        }
                        if !model.listModel.items.isEmpty {
                            NewItemCell()
                        }
                    } header: {
                        TaskListInfoHeader(model: model.headerModel, count: model.listModel.count)
                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 12, trailing: 0))
                    }
                }
                .scrollContentBackground(.hidden)
                Button {

                } label: {
                    ZStack {
                        Circle().fill(Assets.Colors.Color.blue.swiftUIColor)
                        Assets.Icons.plus.swiftUIImage
                    }
                    .frame(width: 44, height: 44)
                }
                .padding(.bottom, 20)
            }
            .navigationTitle(L10n.TaskList.title)
        }
    }

    func makeItemCell(from model: TaskCellModel) -> some View {
        return ItemCell(model: model)
            .alignmentGuide(.listRowSeparatorLeading) { _ in
                return 36
            }
            .swipeActions(edge: .leading, allowsFullSwipe: true) {
                Button {
                    model.done.toggle()
                } label: {
                    Assets.Icons.done.swiftUIImage
                }
                .tint(Assets.Colors.Color.green.swiftUIColor)
            }
            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                Button(role: .destructive) {
                    self.model.listModel.items.removeAll(where: { $0.id == model.id})
                } label: {
                    Assets.Icons.delete.swiftUIImage
                }
                Button {

                } label: {
                    Assets.Icons.info.swiftUIImage
                }
            }
    }

    func makeData() -> [TaskCellModel] {
        if model.headerModel.hidden {
            return model.listModel.items.filter({ !$0.done })
        } else {
            return model.listModel.items
        }
    }
}

struct TaskListUIView_Previews: PreviewProvider {
    // swiftlint:disable all
    static var items = [
        TaskCellModel(item: TodoItem(text: "Купить что-то, где-то, зачем-то, но зачем не очень понятно, но точно чтобы показать как обреза…", deadline: Date.now + 1000000, importance: .basic, done: true)),
        TaskCellModel(item: TodoItem(text: "Text", importance: .important, done: false)),
        TaskCellModel(item: TodoItem(text: "Text", deadline: Date.now + 1000000, importance: .basic, done: false))
    ]
    // swiftlint:enable all
    static var model = TaskListViewModel(headerModel: InfoHeaderModel(hidden: false), listModel: ListModel(items: TaskListUIView_Previews.items), hidden: false)
    static var previews: some View {
        TaskListView(model: model)
    }
}


