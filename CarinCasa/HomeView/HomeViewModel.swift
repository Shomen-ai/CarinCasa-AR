import Foundation

protocol HomeViewModelProtocol: AnyObject {
    var furniture: [Furniture]? { get }
    var sections: Dynamic<[HomeSection]> { get }

    func getData()
}

final class HomeViewModel: HomeViewModelProtocol {

    // MARK: - Properties

    var product: Product? = nil

    var furniture: [Furniture]? {
        product?.furniture
    }

    let sections: Dynamic<[HomeSection]> = .init([])

    // MARK: - Lifecycle

    init() {
        getData()
    }

    // MARK: - Methods

    func getData() {
        APIManager.shared.fetchData { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(product):
                self.product = product
                self.sections.update(with: [.products(product.furniture)])
            case let .failure(error):
                print(error)
            }
        }
    }
}

