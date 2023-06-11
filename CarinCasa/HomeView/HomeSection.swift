enum HomeSection {
    case products([Furniture])
    
    var items: [Furniture] {
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
