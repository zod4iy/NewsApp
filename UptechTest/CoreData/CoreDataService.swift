//
//  CoreDataService.swift
//  UptechTest
//
//  Created by Alex Kurylenko on 5/14/21.
//

import Foundation
import CoreData

enum CoreDataError: Error {
    case failedToGetEntity
}

protocol CoreDataServiceProtocol {
    var managedObjectContext: NSManagedObjectContext { get }
    func saveContext()
}

class CoreDataService: CoreDataServiceProtocol {
    
    static let shared = CoreDataService()
    
    private init() {}

    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "UptechTest")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    var managedObjectContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func saveContext() {
        managedObjectContext.performSaveOrRollback()
    }
}
