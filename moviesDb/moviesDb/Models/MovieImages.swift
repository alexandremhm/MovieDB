//
//  MovieImages.swift
//  moviesDb
//
//  Created by Matheus Henrique Mendes Alexandre on 09/09/22.
//

import Foundation

struct Backdrop: Codable, Hashable {
    let id = Int.random(in: 0..<1000)
    let filePath: String

    enum CodingKeys: String, CodingKey {
        case id
        case filePath = "file_path"
    }
    
    func hash(into hasher: inout Hasher) {
      hasher.combine(id)
    }
}


struct MoviePosters: Codable, Hashable {
    let id: Int
    let backdrops: [Backdrop]
    
    func hash(into hasher: inout Hasher) {
      hasher.combine(id)
    }
}

extension MoviePosters: Equatable {
    static func == (lhs: MoviePosters, rhs: MoviePosters) -> Bool {
        return lhs.id == rhs.id
    }
}


