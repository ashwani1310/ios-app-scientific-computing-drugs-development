//
//  ContentView.swift
//  LyoPronto
//

import SwiftUI

struct ContentView: View {
    
    @Environment(\.horizontalSizeClass) var sizeClass
    
    var body: some View {
        VStack {
            switch sizeClass {
            case .regular:
                SideBarContentView()
            default:
                RootView()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
