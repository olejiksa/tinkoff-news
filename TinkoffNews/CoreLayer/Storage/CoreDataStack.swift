//
//  CoreDataStack.swift
//  TinkoffChat
//
//  Created by Oleg Samoylov on 27/06/2018.
//  Copyright © 2018 Oleg Samoylov. All rights reserved.
//

import CoreData

protocol ICoreDataStack {
    var managedObjectModel: NSManagedObjectModel { get }
    
    var mainContext: NSManagedObjectContext { get }
    var saveContext: NSManagedObjectContext { get }
}

class CoreDataStack: ICoreDataStack {
    
    // MARK: - Dependency
    
    private let resourseName: String
    private let storeType: String
    
    // MARK: - Initializer
    
    init(resourseName: String, storeType: PersistanceStoreType) {
        self.resourseName = resourseName
        switch storeType {
        case .binary:
            self.storeType = NSBinaryStoreType
        case .inMemory:
            self.storeType = NSInMemoryStoreType
        case .sqlite:
            self.storeType = NSSQLiteStoreType
        }
    }
    
    // MARK: - Model
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: resourseName, withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    // MARK: - Coordinator
    
    private var storeUrl: URL {
        let documentUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentUrl.appendingPathComponent("\(resourseName).sqlite")
    }
    
    lazy private var persistanceStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        
        do {
            let options = [NSMigratePersistentStoresAutomaticallyOption: true,
                           NSInferMappingModelAutomaticallyOption: true]
            try coordinator.addPersistentStore(ofType: storeType,
                                               configurationName: nil,
                                               at: storeUrl,
                                               options: options)
        }
        catch {
            assert(false, "Error adding persistent store to coordinator: \(error)")
        }
        
        return coordinator
    }()
    
    // MARK: - Contexts
    
    lazy private var masterContext: NSManagedObjectContext = {
        var masterContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        
        masterContext.persistentStoreCoordinator = persistanceStoreCoordinator
        masterContext.mergePolicy = NSOverwriteMergePolicy
        
        return masterContext
    }()
    
    lazy var mainContext: NSManagedObjectContext = {
        var mainContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        
        mainContext.parent = masterContext
        mainContext.mergePolicy = NSOverwriteMergePolicy
        
        return mainContext
    }()
    
    lazy var saveContext: NSManagedObjectContext = {
        var saveContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        
        saveContext.parent = mainContext
        saveContext.mergePolicy = NSOverwriteMergePolicy
        
        return saveContext
    }()
    
}

enum PersistanceStoreType {
    case binary, inMemory, sqlite
}
