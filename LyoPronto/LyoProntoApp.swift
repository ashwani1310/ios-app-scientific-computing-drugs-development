//
//  LyoProntoApp.swift
//  LyoPronto
//

import SwiftUI

@main
struct LyoProntoApp: App {
  
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, CoreDataProvider.shared.viewContext)
        }
    }
}
