//
//  ToDoViewModel.swift
//  SampleApp
//
//  Created by Harvey Mackie on 17/01/2024.
//

import Foundation
import CosmicSDK

// Model
extension Object {
    var metadata_due_date: String? {
        return self.metadata?["due_date"]?.value as? String
    }
    var metadata_priority: String? {
        return self.metadata?["priority"]?.value as? String
    }
    
    var metadata_is_completed: Bool? {
        return self.metadata?["is_completed"]?.value as? Bool
    }
}

class ToDoViewModel : ObservableObject{
    private let BUCKET = ProcessInfo.processInfo.environment["CONFIG_BUCKET"] ?? ""
    private let READ_KEY = ProcessInfo.processInfo.environment["CONFIG_READ_KEY"]  ?? ""
    private let WRITE_KEY = ProcessInfo.processInfo.environment["CONFIG_WRITE_KEY"]  ?? ""
    private let TYPE = ProcessInfo.processInfo.environment["CONFIG_TYPE"]  ?? ""
    
    private let cosmic = CosmicSDKSwift(
        .createBucketClient(
            bucketSlug: "data-container-production",
            readKey: "uR1hwRoh2SCKjJ4B4H1SbvI1sNvA4rMKXXsplCsA67QyscN1Hd",
            writeKey: "pdu9Xe6DgwCwvehoIkaPZ4425DlIZ1xG3MiJ4BJhSBsjQ8rJq6"
        )
    )
    
    @Published var items: [Object] = []
    @Published var error: ViewModelError?
    
    enum ViewModelError : Error{
        case decodingError(Error)
        case cosmicError(Error)
    }
    
    func fetchData() {
        cosmic.find(type: TYPE) { results in
            switch results {
            case .success(let cosmicSDKResult):
                DispatchQueue.main.async {
                    self.items = cosmicSDKResult.objects
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func completeToDo(id: String, is_completed: Bool) {
        cosmic.updateOne(type: TYPE, id: id, metadata: ["is_completed": is_completed]) { results in
            switch results {
            case .success(_):
                print("Updated \(id)")
                DispatchQueue.main.async {
                    self.fetchData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // ToDoViewModel.swift

    func deleteToDo(id: String) {
        cosmic.deleteOne(type: TYPE, id: id) { results in
            switch results {
            case .success(_):
                print("Deleted \(id)")
                DispatchQueue.main.async {
                    self.fetchData()
                }
            case .failure(let error):	
                print(error)
            }
        }
    }
    
    func createToDo(title: String, due_date: String, priority: String) {
        print("creating to do with \(title) \(due_date) \(priority)")
        cosmic.insertOne(type: TYPE, title: title, metadata: ["due_date": due_date, "priority": priority.capitalized]) { results in
            switch results {
            case .success(_):
                print("Inserted \(title)")
                DispatchQueue.main.async {
                    self.fetchData()
                }
            case .failure(let error):
                print(" \(error)")
            }
        }
    }
}
