//
//  AddNewTodoView.swift
//  SampleApp
//
//  Created by Harvey Mackie on 17/01/2024.
//

import SwiftUI
import CosmicSDK
// AddNewTodoView.swift

struct AddNewTodoView: View {
    @ObservedObject var viewModel: ToDoViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var todoTitle: String = ""
    @State private var todoDueDate: Date = Date()
    @State private var todoDueDateString: String = ""
    @State private var todoPriority: Priority = Priority.low
    
    enum Priority: String, CaseIterable, Identifiable {
        case low, medium, high
        var id: Self { self }
    }
    
    @State private var selectedToDo: Priority = .low
    
#if os(iOS)
    let update = UINotificationFeedbackGenerator()
#endif
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Enter a title", text: $todoTitle, axis: .vertical)
                DatePicker("Pick a date", selection: $todoDueDate, displayedComponents: .date)
                Picker("", selection: $todoPriority, content: {
                    ForEach(Priority.allCases) { priority in
                        Text(priority.rawValue.capitalized)
                    }
                })
                .pickerStyle(.segmented)
            }
            .navigationBarTitle("Add new ToDo")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        update.notificationOccurred(.success)
                        self.dismiss()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            self.viewModel.createToDo(
                                title: todoTitle,
                                due_date: todoDueDateString,
                                priority: todoPriority.rawValue)
                        }
                    } label: {
                        Text("Add")
                            .bold()
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        self.dismiss()
                    } label: {
                        Text("Close")
                    }
                }
            }
            .onAppear {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "YYYY-MM-dd"
                dateFormatter.locale = Locale.init(identifier: "en_GB")
                todoDueDateString = dateFormatter.string(from: todoDueDate)
            }
        }
    }
}

#Preview {
    AddNewTodoView(viewModel: ToDoViewModel())
}
