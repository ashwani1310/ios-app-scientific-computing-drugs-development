//
//  DesignSpaceViewModel.swift
//  LyoPronto
//


import Foundation
import CoreData

final class DesignSpaceViewModel: ObservableObject {
    
    @Published var designSpace: DesignSpace
    @Published var designSpaceHistory: DesignSpaceHistory
    
    private let provider: CoreDataProvider
    
    private var designSpaceContext: NSManagedObjectContext
    private var designSpaceHistoryContext: NSManagedObjectContext
    
    init(provider: CoreDataProvider, designSpace: DesignSpace? = nil, designSpaceHistory: DesignSpaceHistory? = nil) {
        self.provider = provider
        self.designSpaceContext = provider.newContext
        self.designSpaceHistoryContext = provider.newContext
        
        if let designSpace,
           let existingDesignSpaceCopy = provider.saveExistsDesignSpace(designSpace, in: designSpaceContext) {
            self.designSpace = existingDesignSpaceCopy
        } else {
            self.designSpace = DesignSpace(context: self.designSpaceContext)
        }
        
        if let designSpaceHistory,
           let existingDesignSpaceHistoryCopy = provider.historyExistsDesignSpace(designSpaceHistory, in: designSpaceHistoryContext) {
            self.designSpaceHistory = existingDesignSpaceHistoryCopy
        } else {
            self.designSpaceHistory = DesignSpaceHistory(context: self.designSpaceHistoryContext)
        }
        
    }
    
    func newContext() {
        self.designSpaceContext = provider.newContext
        self.designSpaceHistoryContext = provider.newContext
        self.designSpace = DesignSpace(context: self.designSpaceContext)
        self.designSpaceHistory = DesignSpaceHistory(context: self.designSpaceHistoryContext)
    }
    
    func saveRun() throws {
        try provider.persists(in: designSpaceContext)
    }
    
    func saveHistory() throws {
        try provider.persists(in: designSpaceHistoryContext)
    }
    
}

