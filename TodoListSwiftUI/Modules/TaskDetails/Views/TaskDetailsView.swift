//
//  TaskDetailsView.swift
//

import SwiftUI

struct TaskDetailsView: View {
    @State var showCalendar: Bool
    @State var model: TaskDetailsViewModel

    init(model: TaskDetailsViewModel) {
        self._showCalendar = .init(initialValue: false)
        self._model = .init(initialValue: model)
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Assets.Colors.Back.backPrimary.swiftUIColor
                ScrollView {
                    VStack(spacing: 16) {
                        textField
                        detailsView
                        deleteButton
                    }
                    .padding()
                }
            }
            .navigationTitle(L10n.TaskDetails.NavBar.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    cancelButton
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    saveButton
                }
            }
        }
    }

    var textField: some View {
        TextField(L10n.TaskDetails.TextView.placeholder, text: model.$text)
            .padding(EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16))
            .frame(minHeight: 120, alignment: .top)
            .background(Assets.Colors.Back.elevated.swiftUIColor)
            .cornerRadius(16)
    }

    var saveButton: some View {
        Button(L10n.TaskDetails.NavBar.RightButton.title) {

        }
        .bold()
    }

    var cancelButton: some View {
        Button(L10n.TaskDetails.NavBar.LeftButton.title) {

        }
    }

    var deleteButton: some View {
        Button(L10n.TaskDetails.DeleteButton.delete) {

        }
        .frame(maxWidth: .infinity, idealHeight: 56, alignment: .center)
        .background(Assets.Colors.Back.elevated.swiftUIColor)
        .cornerRadius(16)
        .foregroundColor(model.modelDidChange ? Assets.Colors.Label.tertiary.swiftUIColor : Assets.Colors.Color.red.swiftUIColor)
    }

    var detailsView: some View {
        VStack {
            HStack {
                Text(L10n.TaskDetails.Importance.title)
                Spacer()
                Picker(L10n.TaskDetails.Importance.title, selection: model.$importance) {
                    Assets.Icons.Priority.low.swiftUIImage
                    Text(L10n.TaskDetails.Importance.Slider.no)
                    Assets.Icons.Priority.high.swiftUIImage
                }
                .pickerStyle(.segmented)
                .frame(width: 150, height: 36)

            }
            .padding()
            .frame(maxWidth: .infinity, idealHeight: 56)
            divider
            HStack {
                VStack(alignment: .leading) {
                    Text(L10n.TaskDetails.Deadline.title)
                    if let deadline = model.deadline {
                        Text(DateFormatter.dMMMM.string(from: deadline))
                            .foregroundColor(Assets.Colors.Color.blue.swiftUIColor)
                            .bold()
                    }
                }
                Toggle("", isOn: $showCalendar)
                    .onChange(of: showCalendar, perform: { newValue in
                        if !newValue {
                            model.deadline = nil
                            showCalendar = false
                        } else {
                            model.deadline = model.supposedDeadline
                        }
                    })
            }
            .padding()
            .frame(maxWidth: .infinity, idealHeight: 56)
            if showCalendar {
                divider
                calendar
            }
        }
        .background(Assets.Colors.Back.elevated.swiftUIColor)
        .cornerRadius(16)
    }

    var calendar: some View {
        DatePicker("", selection: model.$supposedDeadline, displayedComponents: [.date])
            .datePickerStyle(.graphical)
            .environment(\.locale, .init(identifier: "ru"))
            .onChange(of: model.deadline) { newValue in
                model.changeDeadline(newDeadline: newValue, deadlineIsNeeded: true)
            }
            .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
    }

    var divider: some View {
        Divider()
            .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 0))
    }
}

struct TaskDetailsView_Previews: PreviewProvider {
    static let item = TodoItem(text: "Купить что-то, где-то, зачем-то, но зачем не очень понятно, но точно чтобы показать как обреза…", deadline: Date.now + 1000000, importance: .basic, done: true)
    static var previews: some View {
        TaskDetailsView(model: .init(item: Self.item))
    }
}
