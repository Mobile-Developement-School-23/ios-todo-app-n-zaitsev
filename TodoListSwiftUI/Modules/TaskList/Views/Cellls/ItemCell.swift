//
//  ItemCell.swift
//

import SwiftUI

struct ItemCell: View {
    @ObservedObject
    var model: TaskCellModel

    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            HStack(spacing: 12) {
                radioButton
                infoStack
            }
            Spacer()
            Assets.Icons.chevron.swiftUIImage
        }
        .padding(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
    }

    private var radioButton: some View {
        var image = Assets.Icons.radioButtonCommon.swiftUIImage
        if model.done {
            image = Assets.Icons.radioButtonDone.swiftUIImage
        } else if model.importance == .important {
            image = Assets.Icons.radioButtonImportant.swiftUIImage
        }
        return image.onTapGesture {
            model.done.toggle()
        }
    }

    private var priorityImage: some View {
        switch model.importance {
        case .important:
            return Assets.Icons.Priority.high.swiftUIImage
        default:
            return Assets.Icons.Priority.low.swiftUIImage
        }
    }

    private var deadlineStack: some View {
        HStack(spacing: 2) {
            if let deadline = model.deadline {
                Assets.Icons.calendar.swiftUIImage
                    .renderingMode(.template)
                    .foregroundColor(Assets.Colors.Label.tertiary.swiftUIColor)
                Text(DateFormatter.dMMMM.string(from: deadline))
                    .foregroundColor(Assets.Colors.Label.tertiary.swiftUIColor)
            }
        }
    }

    private var infoStack: some View {
        HStack(spacing: 2) {
            if model.importance != .basic {
                priorityImage
            }
            VStack(alignment: .leading, spacing: 0) {
                Text(model.text)
                    .lineLimit(3)
                    .foregroundColor(labelColor)
                    .strikethrough(model.done, pattern: .solid, color: Assets.Colors.Label.tertiary.swiftUIColor)
                deadlineStack
            }
        }
    }

    private var labelColor: Color {
        model.done ? Assets.Colors.Label.tertiary.swiftUIColor : Assets.Colors.Label.labelPrimary.swiftUIColor
    }
}

struct ItemCellUI_Previews: PreviewProvider {
    static let item = TodoItem(text: "Text", deadline: Date.now + 1000000, importance: .important, done: false)
    static var previews: some View {
        ItemCell(model: TaskCellModel(item: item))
    }
}
