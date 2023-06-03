import UIKit

// MARK: - ProductViewController
final class ProductViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        view.addSubview(loadingView)
        loadingView.startAnimating()
        collectionView.isHidden = true
        
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
        collectionView.register(СonfiguratorCell.self, forCellWithReuseIdentifier: СonfiguratorCell.identifier)
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
    
    public var identifier: String = "" {
        didSet {
                APIManager.shared.findOne(id: self.identifier, completion: { [weak self] result in
                    guard let self = self else { return }
                    switch result {
                    case .success(let furniture):
                        let productSection: ProductSection = {
                            .product(["Henry1", "Henry2", "Henry3", "Henry4", "Henry5"])
                        }()
                        self.sections.append(productSection)
                        let descriptionSection: ProductSection = {
                            .description([furniture.description])
                        }()
                        self.sections.append(descriptionSection)
                        let configuratorDescription: ProductSection = {
                            .configuratorDescription([["КОНФИГУРАТОР", "Воспользуйтесь конфигуратором, чтобы узнать предварительную стоимость изделия"]])
                        }()
                        self.sections.append(configuratorDescription)
                        let configurator: ProductSection = {
                            .configurator(furniture.configurations)
                        }()
                        self.sections.append(configurator)
                        let price: ProductSection = {
                            .price([["ПРЕДВАРИТЕЛЬНАЯ\nСТОИМОСТЬ", "0р"]])
                        }()
                        self.sections.append(price)
                        let order: ProductSection = {
                            .order(["ОСТАВИТЬ ЗАЯВКУ"])
                        }()
                        self.sections.append(order)
                        DispatchQueue.main.async {
                            self.navigationItem.titleView = self.createCustomTitleView(title: furniture.name,
                                                                             subtitle: furniture.type)
                        }
                    case .failure(let error):
                        print(error)
                    }
                })
        }
    }
    
    private var sections: [ProductSection] = [] {
        didSet {
            if self.sections.count == 6 {
                DispatchQueue.main.async {
                    self.loadingView.stopAnimating()
                    self.collectionView.reloadData()
                    self.collectionView.isHidden = false
                }
            }
        }
    }
    
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
    }
}

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
            case .configurator(_):
                return self.createConfiguratorSection()
            case .price(_):
                return self.createPriceSection()
            case .order(_):
                return self.createOrderSection()
            }
        }
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
        section.boundarySupplementaryItems = [self.supplementaryHeaderItem(height: 10)]
        section.supplementaryContentInsetsReference = .automatic
        return section
    }
    
    private func createConfiguratorSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                            heightDimension: .fractionalHeight(1)))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(0.975),
                                                              heightDimension: .fractionalHeight(0.3)),
                                                       subitems: [item])
        group.interItemSpacing = .fixed(10)
        group.edgeSpacing = .init(leading: .fixed(5), top: .fixed(0), trailing: .fixed(5), bottom: .fixed(0))
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .none
        section.interGroupSpacing = 5
        section.boundarySupplementaryItems = [self.supplementaryHeaderItem(height: 10)]
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
        section.boundarySupplementaryItems = [self.supplementaryHeaderItem(height: 10)]
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
        section.boundarySupplementaryItems = [self.supplementaryHeaderItem(height: 10)]
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
            cell.configureCell(imageName: product[indexPath.row])
            return cell
            
        case .description(let description):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DescriptionCell.identifier, for: indexPath) as? DescriptionCell
            else {
                return UICollectionViewCell()
            }
            cell.configureCell(titleString: description[indexPath.row])
            
            return cell
        
        case .configuratorDescription(let confDesc):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: СonfiguratorDescriptionCell.identifier,
                for: indexPath) as? СonfiguratorDescriptionCell
            else {
                return UICollectionViewCell()
            }
            cell.configureCell(titleString: confDesc[indexPath.row][0],
                               subTitleString: confDesc[indexPath.row][1])
            return cell
        case .configurator(let configurator):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: СonfiguratorCell.identifier, for: indexPath) as? СonfiguratorCell
            else {
                return UICollectionViewCell()
            }
            cell.configureCell(titleString: configurator[indexPath.row].title,
                               configurations: configurator[indexPath.row])
            return cell
        case .price(let price):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PriceCell.identifier, for: indexPath) as? PriceCell
            else {
                return UICollectionViewCell()
            }
            cell.configureCell(titleString: price[indexPath.row][0],
                               priceString: price[indexPath.row][1])
            return cell
        case .order(let order):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OrderCell.identifier, for: indexPath) as? OrderCell
            else {
                return UICollectionViewCell()
            }
            cell.configureCell(titleString: order[indexPath.row])
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
    
}

