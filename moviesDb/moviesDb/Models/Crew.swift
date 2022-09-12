import Foundation

struct Crew: Codable {
    let id: Int
    let name: String
    let profilePath: String?
    let job: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case job
        case id
        case profilePath = "profile_path"
    }
}
