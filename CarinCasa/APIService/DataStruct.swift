struct Product: Codable {
    let furniture: [Furniture]
}

// MARK: - Furniture
struct Furniture: Codable {
    let id: String
    let type, name: String
    let description: [String]
    var collectionImage: String
    let images: [String]
    let configurations: [Configuration]
}

// MARK: - Configuration
struct Configuration: Codable {
    let title: String
    let type, price: [String]
    
//    enum CodingKeys: String, CodingKey {
//            case title, type, price
//    }
}

enum APIError: Error {
    case invalidUrl
    case connectionError
    case failToFetchData
    case failToDecodeData
    case unexpectedError
}
