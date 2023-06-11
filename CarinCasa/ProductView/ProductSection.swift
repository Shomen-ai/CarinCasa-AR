enum ProductSection {

    case product([String])
    case description([[String]])
    case configuratorDescription([[String]])
    case configurator([ConfigurationModel])
    case price([[String]])
    case order([String])

    var items: [Any] {
            switch self {
            case .product(let items):
                return items
            case .description(let items):
                return items
            case .configuratorDescription(let items):
                return items
            case .configurator(let items):
                return items
            case .price(let items):
                return items
            case .order(let items):
                return items
            }
        }

    var count: Int {
        return items.count
    }

    var title: String {
        switch self {
        case .product(_):
            return ""
        case .price(_):
            return ""
        case .description(_):
            return ""
        case .order(_):
            return ""
        case .configurator(_):
            return ""
        case .configuratorDescription(_):
            return ""
        }
    }

    mutating func setOrderItems(_ newItems: [[String]]) {
        guard case .price = self else {
            return
        }
        self = .price(newItems)
    }
}
