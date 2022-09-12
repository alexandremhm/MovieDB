import Foundation

// MARK: - Cast
struct Cast: Codable {
    let id: Int
    let name: String
    let profilePath: String?
    let character: String

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case profilePath = "profile_path"
        case character
    }
}
