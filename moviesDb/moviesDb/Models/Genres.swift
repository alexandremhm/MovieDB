import Foundation

struct Genres: Hashable, Decodable {
    var id: Int
    var name: String
    
    func hash(into hasher: inout Hasher) {
      hasher.combine(id)
    }
}

extension Genres: Equatable {
    static func == (lhs: Genres, rhs: Genres) -> Bool {
        return lhs.name == rhs.name && lhs.id == rhs.id
    }
}

struct GenresList: Decodable {
    let genres: [Genres]
}
