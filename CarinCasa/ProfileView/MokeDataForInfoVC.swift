struct MockDataForInfoViewController {
    static let shared = MockDataForInfoViewController()
    
    private let info: InfoSection = {
        .info([.init(title: "FAQ", image: "questionmark.circle"),
                .init(title: "КОНТАКТЫ", image: "info.circle")])
    }()
    
    private let orders: InfoSection = {
        .order([.init(orderImage: "Product1"),
                .init(orderImage: "Product2"),
                .init(orderImage: "Product3"),
                .init(orderImage: "Product4")])
    }()
    
    private let profile: InfoSection = {
        .profile([.init(title: "ПРОФИЛЬ", image: "person.crop.circle.fill")])
    }()
    
    var pageData: [InfoSection] {
        return [profile, orders, info]
    }
}
