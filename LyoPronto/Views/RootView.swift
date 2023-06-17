//
//  RootView.swift
//  LyoPronto
//

import SwiftUI

struct RootView: View {
    
    init() {
        //Use this if NavigationBarTitle is with Large Font
        UINavigationBar.appearance().largeTitleTextAttributes = [.font : UIFont(descriptor: UIFont.systemFont(ofSize: 24.0, weight: .bold).fontDescriptor.withDesign(.rounded)!, size: 24.0), .foregroundColor: UIColor.black.withAlphaComponent(0.6)]

        //Use this if NavigationBarTitle is with displayMode = .inline
        UINavigationBar.appearance().titleTextAttributes = [.font : UIFont(descriptor: UIFont.systemFont(ofSize: 20.0, weight: .bold).fontDescriptor.withDesign(.rounded)!, size: 20.0), .foregroundColor: UIColor.black.withAlphaComponent(0.6)]
    }
    
    var body: some View {
        
        TabView {
            
            NavigationView {
                HomeView()
                .navigationBarHidden(true)
                .navigationTitle("Home")
            }
            .tabItem {
                Image(systemName: "house.fill")
                Text("Home")
            }
            NavigationView {
                GalleryView()
                .navigationBarHidden(true)
                .navigationTitle("Member Companies")
            }
            .tabItem {
                Image(systemName: "photo.stack.fill")
                Text("Member Companies")
            }
            NavigationView {
                CalculatorView()
                    .navigationTitle("Calculators")
            }
            .tabItem {
                Image(systemName: "bookmark.circle.fill")
                Text("Calulators")
            }
        }
        
    }
 }


struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
