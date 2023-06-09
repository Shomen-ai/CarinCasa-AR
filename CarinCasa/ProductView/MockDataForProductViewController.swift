struct MockDataForProductViewController {
    
    static let shared = MockDataForProductViewController()

    private let product: ProductSection = {
        .product([.init(image: "Henry1"),
                 .init(image: "Henry2"),
                 .init(image: "Henry3"),
                 .init(image: "Henry4"),
                 .init(image: "Henry5")])
    }()
    
    private let configuratorDescription: ProductSection = {
        .configuratorDescription(
            [.init(title: "КОНФИГУРАТОР",
                   subtitle: "Воспользуйтесь конфигуратором, чтобы узнать предварительную стоимость изделия")])
    }()
    
    private let configurator: ProductSection = {
        .configurator([.init(title: "ВЫБЕРИТЕ РАЗМЕР, ММ (ВЫСОТА - 750)",
                             configureItems: [ConfigureItems(title: "1110 x 450, h - 600/700", price: "от 139 000 р"),
                                              ConfigureItems(title: "1650 x 450, h - 600/700", price: "от 160 000 р"),
                                              ConfigureItems(title: "2200 x 450, h - 600/700", price: "от 188 000 р"),
                                              ConfigureItems(title: "2750 x 450, h - 600/700", price: "от 202 000 р")
                                             ]),
        
                       .init(title: "ВЫБЕРИТЕ МАТЕРИАЛ СТОЛЕШНИЦЫ",
                             configureItems: [ConfigureItems(title: "ДЕРЕВО ДУБ", price: "+5 000 р"),
                                              ConfigureItems(title: "ДЕРЕВО ОРЕХ", price: "+5 000р"),
                                              ConfigureItems(title: "КЕРАМИКА", price: "+20 000р"),
                                             ]),
                       .init(title: "ВЫБЕРИТЕ МАТЕРИАЛ ФАСАДА",
                             configureItems: [ConfigureItems(title: "В НАТУРАЛЬНОМ ШПОНЕ ДЕРЕВА ИЛИ В ЭМАЛИ", price: "+ 0 р"),
                                              ConfigureItems(title: "КЕРАМИКА", price: "+30 000р")
                                             ])])
    }()
    
    private let description: ProductSection = {
        .description([.init(title2: ["""
                            Комод оснащен распашными ящиками, которые мягко открываются благодаря удобной фрезеровке фасадов. Дверцы могут быть выполнены из премиальной керамики, в отделке под брашированную бронзу или в сером цвете, а также в шпоне благородного дерева.
                            Столешница окрашена в черный цвет под матовым лаком, но можно выполнить ее также из премиальной керамики или в шпоне натурального дерева. Тонкие металлические опоры придают комоду воздушный утонченный вид.

                            Комод доступен в нескольких размерах и может быть использован в гостиной, столовой зонах или прихожей.
                            """])])
    }()
    
    private let price: ProductSection = {
        .price([.init(title: "ПРЕДВАРИТЕЛЬНАЯ\nСТОИМОСТЬ", price: "от 190 000р.")])
    }()
    
    
    private let order: ProductSection = {
        .order([.init(title: "ОСТАВИТЬ ЗАЯВКУ")])
    }()
    
    var pageData: [ProductSection] {
        return [product, description, configuratorDescription, configurator, price, order]
    }
}
