//
//  DesignSpaceExtensions.swift
//  LyoPronto
//

import Foundation
import CoreData

extension DesignSpace {
    
    private static var designSpaceFetchRequest: NSFetchRequest<DesignSpace> {
        NSFetchRequest(entityName: "DesignSpace")
    }
    
    static func fetchAllSaves() -> NSFetchRequest<DesignSpace> {
        let request: NSFetchRequest<DesignSpace> = designSpaceFetchRequest
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \DesignSpace.name, ascending: true)
        ]
        return request
    }
    
    static func filterSaves(_ query: String) -> NSPredicate {
        query.isEmpty ? NSPredicate(value: true) : NSPredicate(format: "name CONTAINS[cd] %@", query)
    }
    
}

extension DesignSpaceHistory {
    
    private static var designSpaceHistoryFetchRequest: NSFetchRequest<DesignSpaceHistory> {
        NSFetchRequest(entityName: "DesignSpaceHistory")
    }
    
    static func fetchHistory() -> NSFetchRequest<DesignSpaceHistory> {
        let request: NSFetchRequest<DesignSpaceHistory> = designSpaceHistoryFetchRequest
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \DesignSpaceHistory.date, ascending: false)
        ]
        request.fetchLimit = 30
        return request
    }
    
    static func filterHistory(_ query: String) -> NSPredicate {
        query.isEmpty ? NSPredicate(value: true) : NSPredicate(format: "dateString CONTAINS[cd] %@", query)
    }
    
    static func deleteExcessHistories(using context: NSManagedObjectContext) {
        let fetchRequest = designSpaceHistoryFetchRequest
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \DesignSpaceHistory.date, ascending: false)
        ]
        
        do {
            let allHistories = try context.fetch(fetchRequest)
            
            if allHistories.count > 30 {
                let historiesToDelete = allHistories.suffix(from: 30)
                for history in historiesToDelete {
                    context.delete(history)
                }
                try context.save()
            }
            
        } catch {
            print("Error deleting histories: \(error)")
        }
    }
    
}
