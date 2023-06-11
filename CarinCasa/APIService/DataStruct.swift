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
    
    var toConfigurationModel: ConfigurationModel {
        var result: [Option] = []
        for index in 0...min(type.count, price.count) - 1 {
            result.append(.init(type: type[index], price: price[index], isSelected: index == 0))
        }
        return .init(title: title, options: result)
    }
}

// MARK: - ConfigurationModel
struct ConfigurationModel: Equatable {
    let title: String
    var options: [Option]
}

struct Option: Equatable {
    let type: String
    let price: String

    var isSelected: Bool = false
}

// MARK: - APIError
enum APIError: Error {
    case invalidUrl
    case connectionError
    case failToFetchData
    case failToDecodeData
    case unexpectedError
}
