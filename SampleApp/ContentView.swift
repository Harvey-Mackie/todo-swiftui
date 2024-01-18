//
//  ContentView.swift
//  SampleApp
//
//  Created by Harvey Mackie on 16/01/2024.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var viewModel = ToDoViewModel()
    @State var showAddNewSheet = false
    
    var body: some View {
        NavigationView{
            VStack {
                Button(action: {showAddNewSheet.toggle()})
                {
                    Image(systemName: "plus.circle")
                        .foregroundColor(.secondary)
                }
                List(viewModel.items, id: \.id){
                    todo in
                        ToDoCell(
                            viewModel: viewModel,
                            id: todo.id ?? "",
                            title: todo.title,
                            date: todo.metadata_due_date ?? "",
                            priority: todo.metadata_priority ?? "",
                            is_completed: todo.metadata_is_completed ?? false
                        )
                }
                NavigationLink(destination: AddNewTodoView(viewModel: viewModel)) {
                    Text("Test Add")
                }
            }
        }
        
        .navigationTitle("Harveys ToDos")
        .sheet(isPresented: $showAddNewSheet) {
            AddNewTodoView(viewModel: viewModel)
        }
        .onAppear{
            viewModel.fetchData()
        }
    }
}

// ContentView.swift	

func replaceTextWithValue(priority: String) -> String {
        switch priority {
        case "Low":
            return "!"
        case "Medium":
            return "!!"
        case "High":
            return "!!!"
        default:
            return "?"
        }
    }

    func determineColor(priority: String) -> Color {
        switch priority {
        case "Low":
            return Color.yellow
        case "Medium":
            return Color.orange
        case "High":
            return Color.red
        default:
            return Color.gray
        }
    }

#Preview {
    ContentView()
}
