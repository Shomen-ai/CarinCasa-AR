import UIKit

// MARK: - ProductViewController
final class ProductViewController: UIViewController {
    
    var selectedItems: Set<IndexPath> = [] {
        didSet {
            print(selectedItems)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        view.addSubview(loadingView)
//        loadingView.startAnimating()
//        collectionView.isHidden = true
        
        setupNavBar()
        navigationItem.rightBarButtonItems = [createCustomButton(titleString: "3D",
                                                                 selector: #selector(showARModule))]
        setupConstraints()
        setDelegate()
        collectionView.collectionViewLayout = createLayout()
        collectionView.reloadData()
    }
    
    private let collectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
//        collectionView.backgroundColor = ColorPalette.backgrounColor
        collectionView.bounces = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(ProductViewCell.self, forCellWithReuseIdentifier: ProductViewCell.identifier)
        collectionView.register(PriceCell.self, forCellWithReuseIdentifier: PriceCell.identifier)
        collectionView.register(СonfiguratorDescriptionCell.self,
                                forCellWithReuseIdentifier: СonfiguratorDescriptionCell.identifier)
        collectionView.register(DescriptionCell.self, forCellWithReuseIdentifier: DescriptionCell.identifier)
        collectionView.register(OrderCell.self, forCellWithReuseIdentifier: OrderCell.identifier)
        collectionView.register(ConfiguratorCell.self, forCellWithReuseIdentifier: ConfiguratorCell.identifier)
        collectionView.register(HeaderSupplementaryView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: HeaderSupplementaryView.identifier)
        return collectionView
    }()
    
    private lazy var loadingView: ZXLoadingView = {
        let rect:CGRect = CGRect.init(x: self.view.center.x, y: self.view.center.y, width: 100, height: 100)
        let view:ZXLoadingView = ZXLoadingView.init(frame:rect)
        view.center = CGPoint.init(x: self.view.center.x, y: self.view.center.y-80)
        view.color = .none
        view.tintColor = UIColor.black
        view.lineWidth = 2.0
        return view
    }()
    
//    private var price: [Int] = [0] {
//        didSet {
//            self.sections[4].setOrderItems( [["ПРЕДВАРИТЕЛЬНАЯ\nСТОИМОСТЬ", "от \(self.price.reduce(0, +))р"]])
//        }
//    }
    
    private var name = ""
//    public var identifier: String = "" {
//        didSet {
//            APIManager.shared.findOne(id: self.identifier, completion: { [weak self] result in
//                guard let self = self else { return }
//                switch result {
//                case .success(let furniture):
//                    let productSection: ProductSection = {
//                        .product(furniture.images)
//                    }()
//                    self.sections.append(productSection)
//                    let descriptionSection: ProductSection = {
//                        .description([furniture.description])
//                    }()
//                    self.sections.append(descriptionSection)
//                    let configuratorDescription: ProductSection = {
//                        .configuratorDescription([["КОНФИГУРАТОР", "Воспользуйтесь конфигуратором, чтобы узнать предварительную стоимость изделия"]])
//                    }()
//                    self.sections.append(configuratorDescription)
//                    let configurator: ProductSection = {
//                        .configurator(furniture.configurations)
//                    }()
//                    self.sections.append(configurator)
//                    let price: ProductSection = {
//                        .price([["ПРЕДВАРИТЕЛЬНАЯ\nСТОИМОСТЬ", "от \(self.price.reduce(0, +))р"]])
//                    }()
//                    self.sections.append(price)
//                    let order: ProductSection = {
//                        .order(["ОСТАВИТЬ ЗАЯВКУ"])
//                    }()
//                    self.sections.append(order)
//                    self.name = furniture.name
//                    self.price = Array(repeating: 0, count: furniture.configurations.count)
//                    DispatchQueue.main.async {
//                        self.navigationItem.titleView = self.createCustomTitleView(title: furniture.name,
//                                                                            subtitle: furniture.type)
//                    }
//                case .failure(let error):
//                    print(error)
//                }
//            })
//        }
//    }
    
//    private var sections: [ProductSection] = [] {
//        didSet {
//            if self.sections.count == 6 {
//                DispatchQueue.main.async {
//                    self.loadingView.stopAnimating()
//                    self.collectionView.reloadData()
//                    self.collectionView.isHidden = false
//                }
//            }
//        }
//    }
    
    private let sections = MockDataForProductViewController.shared.pageData
    
    private func setDelegate() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func setupConstraints() {
        view.addSubview(collectionView)
        view.backgroundColor = .white
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    @objc func showARModule() {
        print("ARModule was showed")
        let newVC = ARViewController()
        newVC.hidesBottomBarWhenPushed = true
        newVC.navigationController?.navigationBar.isHidden = true
        navigationController?.pushViewController(newVC, animated: true)
    }
}

//// MARK: - ConfigureCell Protocol
//extension ProductViewController: ConfiguratorCellDelegate {
//    func didSelectItemsPrice(withTotalSum totalSum: Int, withTag index: Int) {
//        self.price[index] = totalSum
//    }
//}
// MARK: - Create NavigationBar
extension ProductViewController {
    private func setupNavBar() {
        navigationController?.navigationBar.barTintColor = .black
        navigationController?.navigationBar.backgroundColor = .black
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.isTranslucent = false
    }
    
    func createCustomTitleView(title: String, subtitle: String, image: String = "CARINCASA_logo") -> UIView {
        
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: 280, height: 41)
        
        let logoImage: UIImageView = {
            let view = UIImageView()
            view.image = UIImage(named: image)
            view.frame = CGRect(x: 5, y: 0, width: 40, height: 40)
            view.contentMode = .scaleAspectFill
            view.clipsToBounds = true
            return view
        }()
        
        let titleLabel: UILabel = {
            let view = UILabel()
            view.text = title
            view.frame = CGRect(x: 55, y: 0, width: 220, height: 20)
            view.font = UIFont(name: "FuturaPT-Medium", size: 20)
            view.textColor =  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            return view
        }()
        
        let descriptionLabel: UILabel = {
            let view = UILabel()
            view.text = subtitle
            view.frame = CGRect(x: 55, y: 21, width: 220, height: 20)
            view.font = UIFont(name: "FuturaPT-Light", size: 16)
            view.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            return view
        }()
        
        view.addSubview(logoImage)
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        
        return view
    }
    
    func createCustomButton(titleString: String, selector: Selector) -> UIBarButtonItem {
        
        let button = UIButton(type: .system)
        button.setTitle(titleString, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.tintColor = .white
        button.imageView?.contentMode = .scaleAspectFit
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.addTarget(self, action: selector, for: .touchUpInside)
        
        let menuBarItem = UIBarButtonItem(customView: button)
        return menuBarItem
    }
}

extension ProductViewController: ConfiguratorCellDelegate {
    func didTap(item: IndexPath, isSelected: Bool) {
        if isSelected {
            selectedItems.insert(item)
        } else {
            selectedItems.remove(item)
        }
        collectionView.reloadData()
    }
}

// MARK: - Create Layout
extension ProductViewController {
    private func createLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            guard let self = self else { return nil }
            let section = self.sections[sectionIndex]
            switch section {
            case .product(_):
                return self.createProductSection()
            case .description(_):
                return self.createDescriptionSection()
            case .configuratorDescription(_):
                return self.createConfiguratorDescriptionSection()
            case .configurator(let configuration):
                let heights = self.findHeight(conf: configuration)
                return self.createConfiguratorSection(heights: heights)
            case .price(_):
                return self.createPriceSection()
            case .order(_):
                return self.createOrderSection()
            }
        }
    }
    
//    private func findHeight(conf: [Configuration]) -> [Double] {
//        var result: [Double] = []
//        for i in 0..<conf.count {
//            let collectionHeight = 50.0 * Double(conf[i].type.count) + 10.0 * Double((conf[i].type.count - 1))
//            let labelHeightAndMargins = 37.0
//            result.append(collectionHeight + labelHeightAndMargins)
//        }
//        return result
//    }
    
    private func findHeight(conf: [ProductItem]) -> [Double] {
        var result: [Double] = []
        for i in 0..<conf.count {
            let collectionHeight = 50.0 * Double(conf[i].configureItems.count) + 10.0 * Double((conf[i].configureItems.count - 1))
            let labelHeightAndMargins = 37.0
            result.append(collectionHeight + labelHeightAndMargins)
        }
        return result
    }
    
    private func createProductSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                            heightDimension: .fractionalHeight(1)))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                              heightDimension: .fractionalHeight(0.4)),
                                                       subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.boundarySupplementaryItems = [self.supplementaryHeaderItem(height: 5)]
        section.supplementaryContentInsetsReference = .automatic
        return section
    }
    
    private func createDescriptionSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                            heightDimension: .fractionalHeight(1)))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(0.975),
                                                                         heightDimension: .fractionalHeight(0.3)),
                                                       subitems: [item])
        group.edgeSpacing = .init(leading: .fixed(5), top: .fixed(0), trailing: .fixed(5), bottom: .fixed(0))
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .none
        section.interGroupSpacing = 5
        section.boundarySupplementaryItems = [self.supplementaryHeaderItem(height: 5)]
        section.supplementaryContentInsetsReference = .automatic
        return section
    }
    
    private func createConfiguratorDescriptionSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                            heightDimension: .fractionalHeight(1)))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(0.975),
                                                              heightDimension: .estimated(80)),
                                                       subitems: [item])
        group.edgeSpacing = .init(leading: .fixed(5), top: .fixed(0), trailing: .fixed(5), bottom: .fixed(0))
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .none
        section.interGroupSpacing = 5
        section.boundarySupplementaryItems = [self.supplementaryHeaderItem(height: 5)]
        section.supplementaryContentInsetsReference = .automatic
        return section
    }
    
    private func createConfiguratorSection(heights: [Double]) -> NSCollectionLayoutSection {
        var items: [NSCollectionLayoutItem] = []
        for i in 0..<heights.count {
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                                heightDimension: .absolute(heights[i])))
            items.append(item)
        }
        let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(0.975),
                                                                       heightDimension: .absolute(heights.reduce(0, +))),
                                                     subitems: items.compactMap {$0} )
        
//        group.interItemSpacing = .fixed(10)
        group.edgeSpacing = .init(leading: .fixed(5), top: .fixed(0), trailing: .fixed(5), bottom: .fixed(0))
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .none
        section.interGroupSpacing = 5
        section.boundarySupplementaryItems = [self.supplementaryHeaderItem(height: 5)]
        section.supplementaryContentInsetsReference = .automatic
        return section
    }
    
    private func createPriceSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                            heightDimension: .fractionalHeight(1)))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(0.975),
                                                              heightDimension: .fractionalHeight(0.1)),
                                                       subitems: [item])
        group.edgeSpacing = .init(leading: .fixed(5), top: .fixed(0), trailing: .fixed(5), bottom: .fixed(0))
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .none
        section.interGroupSpacing = 5
        section.boundarySupplementaryItems = [self.supplementaryHeaderItem(height: 5)]
        section.supplementaryContentInsetsReference = .automatic
        return section
    }
    
    private func createOrderSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                            heightDimension: .fractionalHeight(1)))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(0.975),
                                                                         heightDimension: .estimated(70)),
                                                       subitems: [item])
        group.edgeSpacing = .init(leading: .fixed(5), top: .fixed(0), trailing: .fixed(5), bottom: .fixed(5))
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .none
        section.interGroupSpacing = 5
        section.boundarySupplementaryItems = [self.supplementaryHeaderItem(height: 5)]
        section.supplementaryContentInsetsReference = .automatic
        return section
    }
    
    private func supplementaryHeaderItem(height: Double) -> NSCollectionLayoutBoundarySupplementaryItem {
            return .init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(height)),
                  elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
    }
}

// MARK: - UICollectionViewDelegate
extension ProductViewController: UICollectionViewDelegate {
    
}

// MARK: - UICollectionViewDataSource
extension ProductViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        sections[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch sections[indexPath.section] {
            
        case .product(let product):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductViewCell.identifier, for: indexPath) as? ProductViewCell
            else {
                return UICollectionViewCell()
            }
//            cell.configureCell(imageName: product[indexPath.row], name: name)
            cell.configureCell(imageName: product[indexPath.row].image, name: name)
            return cell
            
        case .description(let description):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DescriptionCell.identifier, for: indexPath) as? DescriptionCell
            else {
                return UICollectionViewCell()
            }
//            cell.configureCell(titleString: description[indexPath.row])
            cell.configureCell(titleString: description[indexPath.row].title2)
            return cell
        
        case .configuratorDescription(let confDesc):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: СonfiguratorDescriptionCell.identifier,
                for: indexPath) as? СonfiguratorDescriptionCell
            else {
                return UICollectionViewCell()
            }
            
//            cell.configureCell(titleString: confDesc[indexPath.row][0],
//                               subTitleString: confDesc[indexPath.row][1])
            cell.configureCell(titleString: confDesc[indexPath.row].title,
                               subTitleString: confDesc[indexPath.row].subtitle)
            return cell
        case .configurator(let configurator):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ConfiguratorCell.identifier, for: indexPath) as? ConfiguratorCell
            else {
                return UICollectionViewCell()
            }
//            cell.configureCell(titleString: configurator[indexPath.row].title,
//                               configurations: configurator[indexPath.row])
            cell.configureCell(titleString: configurator[indexPath.row].title,
                               configurations: configurator[indexPath.row].configureItems)
            cell.delegate = self
            cell.tag = indexPath.item
            cell.selectedItems = selectedItems
            return cell
        case .price(let price):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PriceCell.identifier, for: indexPath) as? PriceCell
            else {
                return UICollectionViewCell()
            }
//            cell.configureCell(titleString: price[indexPath.row][0],
//                               priceString: price[indexPath.row][1])
            cell.configureCell(titleString: price[indexPath.row].title,
                                           priceString: price[indexPath.row].price)
            return cell
        case .order(let order):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OrderCell.identifier, for: indexPath) as? OrderCell
            else {
                return UICollectionViewCell()
            }
//            cell.configureCell(titleString: order[indexPath.row])
            cell.configureCell(titleString: order[indexPath.row].title)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: HeaderSupplementaryView.identifier,
                for: indexPath) as? HeaderSupplementaryView
            else {
                return UICollectionReusableView()
            }
            header.configureHeader(titleString: sections[indexPath.section].title)
            return header
        default:
            return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch sections[indexPath.section] {
        case .configurator(_):
            print("\(indexPath.row) - \(indexPath.item) ")
        default:
            return
        }
    }
}

