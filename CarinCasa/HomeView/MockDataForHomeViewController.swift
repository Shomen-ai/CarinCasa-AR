struct MockDataForHomeViewController {
    static let shared = MockDataForHomeViewController()

    private let products: HomeSection = {
        .products([.init(title: "HENRY", image: "Product1"),
                   .init(title: "MERCURY", image: "Product2"),
                   .init(title: "LOUIS", image: "Product3"),
                   .init(title: "LUNAR PREMIUM", image: "Product4"),
                   .init(title: "BRISTOL", image: "Product5"),
                   .init(title: "YOKO", image: "Product6"),
                   .init(title: "AMBER", image: "Product7"),
                   .init(title: "SCARLETT", image: "Product8"),
                   .init(title: "SCARLETT LIGHT", image: "Product9"),])
    }()

    var pageData: [HomeSection] {
        return [products]
    }
}
