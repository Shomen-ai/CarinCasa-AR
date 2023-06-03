struct ProductItem {
    var title: String = ""
    var subtitle: String = ""
    var image: String = ""
    var price: String = ""
    var configureItems: [ConfigureItems] = []
}

struct ConfigureItems {
    let title: String
    let price: String
}
