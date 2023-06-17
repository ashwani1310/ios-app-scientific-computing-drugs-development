//
//  FloatingTextfield.swift
//  LyoPronto
//


import SwiftUI

struct FloatingTextfield: View {
    
	var title: String
    var editable: Bool
	@Binding var text: String
	
    init(_ title: String, editable: Bool, text: Binding<String>) {
		self.title = title
        self.editable = editable
		self._text = text
	}
	
	var body: some View {
		HStack {
			ZStack(alignment: .leading) {
				withAnimation {
					Text(title)
						.foregroundColor(text.isEmpty ? Color(.placeholderText) : .accentColor)
						.offset(y: text.isEmpty ? 0 : -25)
						.scaleEffect(text.isEmpty ? 1: 0.8, anchor: .leading)
				}
                if editable {
                    TextField("", text: $text)
                } else {
                    Text(text)
                        .padding(.vertical, 1)
                }
			}
			.padding(.top, 15)
		}
	}
}
