//
//  CommonStructs.swift
//  LyoPronto
//

import Foundation

struct ImageClass: Codable, Hashable, Identifiable {
    var id = UUID()
    var name: String
    var caption: String
}


struct ResourcesByYear: Codable, Hashable, Identifiable {
    var id = UUID()
    var year: String
    var resources: [ResourceLink]
}

struct ResourceLink: Codable, Hashable, Identifiable {
    var id = UUID()
    var label: String
    var link: String
    var symbol: String
}

struct Photo: Identifiable {
    var id = UUID()
    var name: String
    var imageName: String
    var year: String
    var url: String
}

struct ShareFile: Identifiable {
    let id = UUID()
    let filePath: URL
}
