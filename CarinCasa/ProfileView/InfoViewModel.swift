import Foundation

protocol InfoViewModelProtocol: AnyObject {
    
    var orders: [[String: String]] { get }
    var sections: Dynamic<[InfoSection]> { get }
    
    func updateSection()
}

final class InfoViewModel: InfoViewModelProtocol {
    
    // MARK: - Properties
    
    var orders: [[String : String]] = []
    
    var sections: Dynamic<[InfoSection]> = .init([])
    
    // MARK: - Lifecycle
    
    init() {
        updateSection()
    }
    
    // MARK: - Methods
    
    func updateSection() {
        orders = UserDefaults.standard.array(forKey: "userOrders") as? [[String: String]] ?? []
        
        let info: InfoSection = {
            .info([.init(title: "FAQ", image: "questionmark.circle"),
                    .init(title: "КОНТАКТЫ", image: "info.circle")])
        }()
        
        var orderItems: [OrderItem] = []
        
        for dictionary in orders {
            if let orderImage = dictionary["collectionImage"],
               let id = dictionary["id"] {
                let orderItem = OrderItem(orderImage: orderImage, id: id)
                orderItems.append(orderItem)
            }
        }
        
        let orders: InfoSection = {
            .order(orderItems)
        }()
        
        let profile: InfoSection = {
            .profile([.init(title: "ПРОФИЛЬ", image: "person.crop.circle.fill")])
        }()
        
        sections.update(with: [profile, orders, info])
    }
}


