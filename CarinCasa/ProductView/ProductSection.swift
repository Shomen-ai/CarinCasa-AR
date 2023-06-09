//enum ProductSection {
//
//    case product([String])
//    case description([[String]])
//    case configuratorDescription([[String]])
//    case configurator([Configuration])
//    case price([[String]])
//    case order([String])
//
//    var items: [Any] {
//            switch self {
//            case .product(let items):
//                return items
//            case .description(let items):
//                return items
//            case .configuratorDescription(let items):
//                return items
//            case .configurator(let items):
//                return items
//            case .price(let items):
//                return items
//            case .order(let items):
//                return items
//            }
//        }
//
//    var count: Int {
//        return items.count
//    }
//
//    var title: String {
//        switch self {
//        case .product(_):
//            return ""
//        case .price(_):
//            return ""
//        case .description(_):
//            return ""
//        case .order(_):
//            return ""
//        case .configurator(_):
//            return ""
//        case .configuratorDescription(_):
//            return ""
//        }
//    }
//
//    mutating func setOrderItems(_ newItems: [[String]]) {
//        guard case .price = self else {
//            return
//        }
//        self = .price(newItems)
//    }
//}

enum ProductSection {
    
    case product([ProductItem])
    case description([ProductItem])
    case configuratorDescription([ProductItem])
    case configurator([ProductItem])
    case price([ProductItem])
    case order([ProductItem])
    
    var items: [ProductItem] {
        switch self {
        case    .product(let items),
                .price(let items),
                .description(let items),
                .configurator(let items),
                .configuratorDescription(let items),
                .order(let items):
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
}
