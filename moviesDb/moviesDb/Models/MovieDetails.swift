import Foundation

struct MovieDetails: Decodable, Encodable {
    let id: Int
    let backdropPath: String?
    let genres: [Genre]
    let posterPath: String?
    let releaseDate: String
    let runtime: Int?
    let title: String
    let voteAverage: Float
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case genres
        case runtime
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
    }
}
