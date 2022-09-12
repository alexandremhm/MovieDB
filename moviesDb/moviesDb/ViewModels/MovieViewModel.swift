import UIKit

struct Movie2: Hashable {
    var id: Int
    var voteAverage: Double
    var title: String
    var originalTitle: String
    var popularity: Double
    var posterPath: String
    var backdropPath: String
    var overview: String
    var releaseDate: String
    var genres: [Genre]
    var crew: [Crew]
    var posterCollectionPhotos: [MoviePhotos]
    
    
    func hash(into hasher: inout Hasher) {
      hasher.combine(id)
    }
}

extension Movie2: Equatable {
    static func == (lhs: Movie2, rhs: Movie2) -> Bool {
        return lhs.title == rhs.title && lhs.id == rhs.id
    }
}

class MovieViewModel {
    static let shared = MovieViewModel()
    
//    func searchMoviesBy(genre: Genre) -> [Movie2] {
//       nowPlayingMovies.filter {
//            $0.genres.contains(genre)
//        }
//    }
//
//    func orderMoviesByReleaseDate(_ movies: [Movie]) -> [Movie] {
//        movies.sorted {
//            $0.releaseDate > $1.releaseDate
//        }
//    }
//
//    func orderMovies(_ movies: [Movie]) -> [Movie] {
//        movies.sorted {
//            $0.title < $1.title
//        }
//    }
}
