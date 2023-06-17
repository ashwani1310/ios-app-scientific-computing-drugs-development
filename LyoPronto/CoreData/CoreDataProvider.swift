//
//  PrimaryDryProvider.swift
//  LyoPronto
//

import Foundation
import CoreData

class CoreDataProvider {
    
    let persistentContainer: NSPersistentContainer
    static let shared = CoreDataProvider()
    
    var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    var newContext: NSManagedObjectContext {
        persistentContainer.newBackgroundContext()
    }
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "LyoProntoCD")
        persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError ("Unable to initialize Core Data \(error)")
            }
        }
    }
    
    func saveExistsPrimaryDry(_ PrimaryDry: PrimaryDry, in context: NSManagedObjectContext) -> PrimaryDry? {
        try? context.existingObject(with: PrimaryDry.objectID) as? PrimaryDry
    }
    
    func historyExistsPrimaryDry(_ PrimaryDryHistory: PrimaryDryHistory, in context: NSManagedObjectContext) -> PrimaryDryHistory? {
        try? context.existingObject(with: PrimaryDryHistory.objectID) as? PrimaryDryHistory
    }
    
    
    func saveExistsFreezing(_ Freezing: Freezing, in context: NSManagedObjectContext) -> Freezing? {
        try? context.existingObject(with: Freezing.objectID) as? Freezing
    }
    
    func historyExistsFreezing(_ FreezingHistory: FreezingHistory, in context: NSManagedObjectContext) -> FreezingHistory? {
        try? context.existingObject(with: FreezingHistory.objectID) as? FreezingHistory
    }
    
    func saveExistsDesignSpace(_ DesignSpace: DesignSpace, in context: NSManagedObjectContext) -> DesignSpace? {
        try? context.existingObject(with: DesignSpace.objectID) as? DesignSpace
    }
    
    func historyExistsDesignSpace(_ DesignSpaceHistory: DesignSpaceHistory, in context: NSManagedObjectContext) -> DesignSpaceHistory? {
        try? context.existingObject(with: DesignSpaceHistory.objectID) as? DesignSpaceHistory
    }
    
    
    func persists(in context: NSManagedObjectContext) throws {
        if context.hasChanges {
            try context.save()
        }
    }
}
