import Foundation

struct Genre: Decodable, Encodable {
    var id: Int
    var name: String
}

extension Genre: Equatable {
    static func == (lhs: Genre, rhs: Genre) -> Bool {
        return lhs.name == rhs.name && lhs.id == rhs.id
    }
}
