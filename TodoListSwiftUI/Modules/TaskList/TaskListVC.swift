//
//  TaskListVC.swift
//

import SwiftUI

struct TaskListVC: View {
    var body: some View {
        TaskListView(model: TaskListUIView_Previews.model)
    }
}

struct TaskListVC_Previews: PreviewProvider {
    static var previews: some View {
        TaskListVC()
    }
}
