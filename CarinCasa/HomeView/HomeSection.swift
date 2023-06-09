enum HomeSection {
    case products([HomeItem])
    
    var items: [HomeItem] {
        switch self {
            case .products(let items):
            return items
        }
    }
    
    var count: Int {
        return items.count
    }
    
    var title: String {
        switch self {
        case .products(_):
            return ""
        }
    }
}
