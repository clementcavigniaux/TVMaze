import Foundation

struct Serie: Codable {
    var name: String
    var id: Int
    var network: Network?
    var status: String
    var genres: [String]
    var summary: String
    var image: Image
}
