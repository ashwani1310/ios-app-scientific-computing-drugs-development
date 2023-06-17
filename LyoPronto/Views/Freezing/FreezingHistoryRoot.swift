//
//  FreezingHistoryRoot.swift
//  LyoPronto
//

import SwiftUI

struct FreezingHistoryRootView: View {

    @State private var selectedPickerSegnment = 0

    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack {
                switch selectedPickerSegnment {
                    case 0:
                        FreezingHistoryListingView()
                    case 1:
                        FreezingSaveListingView()
                    default:
                        EmptyView()
                }
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Picker("", selection: $selectedPickerSegnment) {
                        Text("History".capitalized).tag(0)
                        Text("Saved".capitalized).tag(1)
                    }
                    .pickerStyle(.segmented)
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Back")
                    }
                }
            }
        }
        
    }
}
