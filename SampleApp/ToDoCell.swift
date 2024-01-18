//
//  ToDoCell.swift
//  SampleApp
//
//  Created by Harvey Mackie on 17/01/2024.
//

import SwiftUI

struct ToDoCell: View {
    @ObservedObject var viewModel: ToDoViewModel
    @State var id: String = ""
    @State var title: String = ""
    @State var date: String = ""
    @State var priority: String = ""
    @State var is_completed: Bool = false
    
    var body: some View {
        Button {
            is_completed.toggle()
            viewModel.completeToDo(id: id, is_completed: is_completed)
        } label: {
            VStack {
                HStack {
                    Text(title)
                    Spacer()
                    Image(systemName: is_completed ? "checkmark.circle.fill" : "checkmark.circle")
                        .foregroundStyle(is_completed ? .green : .secondary)
                }
                HStack {
                    Text(parseDate(from: date)?.description ?? "")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Spacer()
                    Text(replaceTextWithValue(priority: priority))
                        .fontWeight(.black)
                        .foregroundStyle(determineColor(priority: priority))
                }
            }
        }
        .buttonStyle(.plain)
        .swipeActions(edge: .trailing) {
            Button(role: .destructive) {
                withAnimation {
                    viewModel.deleteToDo(id: id)
                }
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
    }
}

#Preview {	
    ToDoCell(viewModel: ToDoViewModel())
}
