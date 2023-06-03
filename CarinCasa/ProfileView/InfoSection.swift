enum InfoSection {
    case order([OrderItem])
    case info([InfoItem])
    case profile([ProfileItem])
    
    var orderItems: [OrderItem]? {
        if case let .order(items) = self {
            return items
        }
        return nil
    }
    
    var infoItems: [InfoItem]? {
        if case let .info(items) = self {
            return items
        }
        return nil
    }
    
    var profileItems: [ProfileItem]? {
        if case let .profile(items) = self {
            return items
        }
        return nil
    }
    
    var count: Int {
        switch self {
        case .order(let items):
            return items.count
        case .info(let items):
            return items.count
        case .profile(let items):
            return items.count
        }
    }
    
    var title: String {
        switch self {
        case .order(_):
            return "ЗАКАЗЫ"
        case .info(_):
            return ""
        case .profile(_):
            return ""
        }
    }
}
