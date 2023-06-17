//
//  SideBarContentView.swift
//  LyoPronto
//

import SwiftUI

struct SideBarContentView: View {
    
    @State var selectedSidebarMenuItem: menuItem.ID? = menuItem.home.id
    
    var body: some View {
        NavigationView {
            List(selection: $selectedSidebarMenuItem) {
                ForEach([menuItem.home, menuItem.gallery, menuItem.calculator]) {
                    navigationLinkForMenuItem($0)
                }
                .navigationTitle("LyoHUB")
            }
            .listStyle(.sidebar)
            HomeView()
        }
    }
    
    private func navigationLinkForMenuItem(_ item: menuItem) -> some View {
        NavigationLink(destination: viewForMenuItem(item: item), tag: item.id, selection: $selectedSidebarMenuItem) {
            Label(item.prettyText, systemImage: item.systemImage)
        }
    }
    
    @ViewBuilder
    private func viewForMenuItem( item: menuItem) -> some View {
        switch item {
        case .home:
            HomeView()
        case .gallery:
            GalleryView()
        case .calculator:
            CalculatorView()
        }
    }
}

import Foundation

enum menuItem: CaseIterable, Identifiable {
    case home
    case gallery
    case calculator
    
    init?(id: menuItem.ID?) {
        switch id {
        case menuItem.home.id:
            self = .home
        case menuItem.gallery.id:
            self = .gallery
        case menuItem.calculator.id:
            self = .calculator
        default:
            self = .home
        }
    }

    
    var id: String {
        switch self {
        case .home:
            return "home"
        case .gallery:
            return "members"
        case .calculator:
            return "calculators"
        }
    }
    
    var prettyText: String {
        switch self {
        case .home:
            return "Home"
        case .gallery:
            return "Member Companies"
        case .calculator:
            return "Calculators"
        }
    }
    
    var systemImage: String {
        switch self {
        case .home:
            return "house.fill"
        case .gallery:
            return "photo.stack.fill"
        case .calculator:
            return "bookmark.circle.fill"
        }
    }
    
    static var allCases: [menuItem] {
        return [.home, .gallery, .calculator]
    }
}
