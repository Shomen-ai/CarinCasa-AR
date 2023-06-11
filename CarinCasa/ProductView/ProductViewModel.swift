
import Foundation

protocol ProductViewModelProtocol: AnyObject {
    
    // MARK: - Properties
    
    var sections: Dynamic<[ProductSection]> { get }
    var furniture: Furniture? { get }
    var configurations: [ConfigurationModel] { get set }
    var productId: String { get }
    var price: [Int] { get }
    var totalSum: Int { get set }
    // MARK: - Methods
    
    func getData()
    func updateSections()
}

final class ProductViewModel: ProductViewModelProtocol {
    
    // MARK: - Properties
    
    var sections: Dynamic<[ProductSection]> = .init([])
    
    var furniture: Furniture? = nil
    
    var configurations: [ConfigurationModel] = .init([])
    
    var productId: String
    
    var price: [Int] = [0]
    
    var totalSum: Int = 0
    // MARK: - Lifecycle
    
    init(productId: String) {
        self.productId = productId
        getData()
    }
    
    // MARK: - Methods
    
    func getData() {
        APIManager.shared.findOne(id: productId) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(furniture):
                self.furniture = furniture
                self.configurations = furniture.configurations.map({ $0.toConfigurationModel })
                self.price = Array(repeating: 0, count: furniture.configurations.count)
                self.updateSections()
            case let .failure(error):
                print(error)
            }
        }
    }
    
    func updateSections() {
        guard let furniture = furniture else {
            return
        }
        
        self.sections = .init([
            .product(furniture.images),
            .description([furniture.description]),
            .configuratorDescription([["КОНФИГУРАТОР", "Воспользуйтесь конфигуратором, чтобы узнать предварительную стоимость изделия"]]),
            .configurator(configurations),
            .price([["ПРЕДВАРИТЕЛЬНАЯ\nСТОИМОСТЬ",
                     "от \(String(totalSum).formattedWithSpaceSeparator() ?? "-")₽"]]),
            .order(["ОСТАВИТЬ ЗАЯВКУ"]),
        ])
        
        // TODO: - Завязан на конкретное число 6, могут возникнуть проблемы когда это число вдруг поменяется
        guard sections.value.count == 6 else {
            return
        }
    }
    
}
