//
//  PrimaryDryExtensions.swift
//  LyoPronto
//

import Foundation
import CoreData

extension PrimaryDry {
    
    private static var primaryDryFetchRequest: NSFetchRequest<PrimaryDry> {
        NSFetchRequest(entityName: "PrimaryDry")
    }
    
    static func fetchAllSaves() -> NSFetchRequest<PrimaryDry> {
        let request: NSFetchRequest<PrimaryDry> = primaryDryFetchRequest
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \PrimaryDry.name, ascending: true)
        ]
        return request
    }
    
    static func filterSaves(_ query: String) -> NSPredicate {
        query.isEmpty ? NSPredicate(value: true) : NSPredicate(format: "name CONTAINS[cd] %@", query)
    }
    
}

extension PrimaryDryHistory {
    
    private static var primaryDryHistoryFetchRequest: NSFetchRequest<PrimaryDryHistory> {
        NSFetchRequest(entityName: "PrimaryDryHistory")
    }
    
    static func fetchHistory() -> NSFetchRequest<PrimaryDryHistory> {
        let request: NSFetchRequest<PrimaryDryHistory> = primaryDryHistoryFetchRequest
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \PrimaryDryHistory.date, ascending: false)
        ]
        request.fetchLimit = 30
        return request
    }
    
    static func filterHistory(_ query: String) -> NSPredicate {
        query.isEmpty ? NSPredicate(value: true) : NSPredicate(format: "dateString CONTAINS[cd] %@", query)
    }
    
    
    static func deleteExcessHistories(using context: NSManagedObjectContext) {
        let fetchRequest = primaryDryHistoryFetchRequest
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \PrimaryDryHistory.date, ascending: false)
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
