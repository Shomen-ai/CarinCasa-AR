struct ProductItem {
    var title: String = ""
    var subtitle: String = ""
    var image: String = ""
    var price: String = ""
    var configureItems: [ConfigureItems] = []
    var title2: [String] = [""]
}

struct ConfigureItems {
    let title: String
    let price: String
}
