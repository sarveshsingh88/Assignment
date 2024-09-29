//
//  CoreDataStack.swift
//  NewsReader
//
//  Created by Sarvesh on 25/09/24.
//

import CoreData

class CoreDataStack {
    
    // MARK: Properties
    fileprivate let modelName: String
    
    lazy var mainContext: NSManagedObjectContext = {
        return self.storeContainer.viewContext
    }()
    
    private lazy var managedObjectModel: NSManagedObjectModel = {
        return storeContainer.managedObjectModel
        /*guard let modelURL = Bundle.main.url(forResource: self.modelName, withExtension: "momd") else {
         fatalError("Unable to Find Data Model")
         }
         
         guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
         fatalError("Unable to Load Data Model")
         }
         
         return managedObjectModel*/
    }()
    
    lazy var storeContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: self.modelName)
        
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    // MARK: Initializers
    init(modelName: String) {
        self.modelName = modelName
    }
}
