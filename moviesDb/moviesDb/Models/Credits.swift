//
//  Credits.swift
//  moviesDb
//
//  Created by Matheus Henrique Mendes Alexandre on 09/09/22.
//

import Foundation


struct Credits: Codable, Hashable {
    var id: Int
    let cast: [Cast]
    let crew: [Crew]
    
    func hash(into hasher: inout Hasher) {
      hasher.combine(id)
    }
}


extension Credits: Equatable {
    static func == (lhs: Credits, rhs: Credits) -> Bool {
        return lhs.id == rhs.id
    }
}
