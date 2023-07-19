//
//  TaskListInfoHeader.swift
//

import SwiftUI

struct TaskListInfoHeader: View {
    @ObservedObject var model: InfoHeaderModel
    var body: some View {
        HStack {
            Text(L10n.TaskList.InfoCell.Info.title(model.count))
            Spacer()
            Button(buttonTitle) {
                model.hidden.toggle()
            }
            .bold(true)
        }
    }

    var buttonTitle: String {
        if model.hidden {
            return L10n.TaskList.InfoCell.Action.Show.title
        } else {
            return L10n.TaskList.InfoCell.Action.Hide.title
        }
    }
}

struct TaskListInfoUICell_Previews: PreviewProvider {
    static var previews: some View {
        TaskListInfoHeader(model: InfoHeaderModel(count: 1))
    }
}
