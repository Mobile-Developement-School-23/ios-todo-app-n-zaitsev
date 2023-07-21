//
//  TaskDetailsVC.swift
//

import SwiftUI

struct TaskDetailsVC: View {
    var body: some View {
        TaskDetailsView(model: .init(item: TaskDetailsView_Previews.item))
    }
}

struct TaskDetailsVC_Previews: PreviewProvider {
    static var previews: some View {
        TaskDetailsVC()
    }
}
