//
//  NewItemCell.swift
//

import SwiftUI

struct NewItemCell: View {
    var body: some View {
        HStack(alignment: .center) {
            Text(L10n.TaskList.CreateNew.title)
                .foregroundColor(Assets.Colors.Label.tertiary.swiftUIColor)
            Spacer()
        }
        .padding(EdgeInsets(top: 8, leading: 36, bottom: 8, trailing: 0))
    }
}

struct NewItemUICell_Previews: PreviewProvider {
    static var previews: some View {
        NewItemCell()
    }
}
