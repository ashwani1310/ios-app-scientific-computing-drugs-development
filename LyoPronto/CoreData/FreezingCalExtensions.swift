//
//  FreezingCalExtensions.swift
//  LyoPronto
//


import Foundation
import CoreData

extension Freezing {
    
    private static var freezingFetchRequest: NSFetchRequest<Freezing> {
        NSFetchRequest(entityName: "Freezing")
    }
    
    static func fetchAllSaves() -> NSFetchRequest<Freezing> {
        let request: NSFetchRequest<Freezing> = freezingFetchRequest
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \Freezing.name, ascending: true)
        ]
        return request
    }
    
    static func filterSaves(_ query: String) -> NSPredicate {
        query.isEmpty ? NSPredicate(value: true) : NSPredicate(format: "name CONTAINS[cd] %@", query)
    }
    
}

extension FreezingHistory {
    
    private static var freezingHistoryFetchRequest: NSFetchRequest<FreezingHistory> {
        NSFetchRequest(entityName: "FreezingHistory")
    }
    
    static func fetchHistory() -> NSFetchRequest<FreezingHistory> {
        let request: NSFetchRequest<FreezingHistory> = freezingHistoryFetchRequest
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \FreezingHistory.date, ascending: false)
        ]
        request.fetchLimit = 30
        return request
    }
    
    static func filterHistory(_ query: String) -> NSPredicate {
        query.isEmpty ? NSPredicate(value: true) : NSPredicate(format: "dateString CONTAINS[cd] %@", query)
    }
    
    static func deleteExcessHistories(using context: NSManagedObjectContext) {
        let fetchRequest = freezingHistoryFetchRequest
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \FreezingHistory.date, ascending: false)
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
