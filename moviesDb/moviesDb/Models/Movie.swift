import Foundation

struct Movie: Hashable, Decodable {
    var id: Int
    var title: String
    var overview: String
    var posterPath: String?
    var backdropPath: String?
    var releaseDate: String
    var voteAverage: Double
    var genres: [Int]
    
    func hash(into hasher: inout Hasher) {
      hasher.combine(id)
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case overview
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case genres = "genre_ids"
    }
}

extension Movie: Equatable {
    static func == (lhs: Movie, rhs: Movie) -> Bool {
        return lhs.title == rhs.title && lhs.id == rhs.id
    }
}

struct MovieList: Decodable {
    let results: [Movie]
}
