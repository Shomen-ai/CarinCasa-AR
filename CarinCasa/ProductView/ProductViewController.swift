import UIKit

// MARK: - ProductViewController
final class ProductViewController: UIViewController {

    // MARK: - UI Components

    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        collectionView.bounces = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(ProductViewCell.self)
        collectionView.register(PriceCell.self)
        collectionView.register(СonfiguratorDescriptionCell.self)
        collectionView.register(DescriptionCell.self)
        collectionView.register(OrderCell.self)
        collectionView.register(ConfiguratorCell.self)
        collectionView.register(HeaderSupplementaryView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader)
        return collectionView
    }()

    private lazy var loadingView: ZXLoadingView = {
        let rect: CGRect = CGRect(x: self.view.center.x, y: self.view.center.y, width: 100, height: 100)
        let view: ZXLoadingView = ZXLoadingView(frame:rect)
        view.center = CGPoint(x: self.view.center.x, y: self.view.center.y - 80)
        view.color = .none
        view.tintColor = .black
        view.lineWidth = 2.0
        return view
    }()

    private lazy var arBarButtonItem: UIBarButtonItem = createBarButtonItem(title: "3D",
                                                                            selector: #selector(showARModule))

    // MARK: - Properties
    
    private let viewModel: ProductViewModelProtocol
    // MARK: - Lifecycle

    init(viewModel: ProductViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setLoading(true)
        
        setupNavBar()
        
        setupConstraints()
        setDelegate()
        collectionView.collectionViewLayout = createLayout()
        collectionView.reloadData()
        
        viewModel.sections.add(subscriber: "viewModel.sections.product") { [weak self] old, new in
            guard let self = self else {
                return
            }
            DispatchQueue.main.async { [weak self] in
                self?.setLoading(false)
                self?.collectionView.reloadData()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.getData()
        viewModel.updateSections()
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {
                return
            }
            guard let furniture = self.viewModel.furniture else {
                return
            }
            self.navigationItem.titleView = self.createTitleView(title: furniture.name,
                                                                 subtitle: furniture.type)
            self.collectionView.reloadData()
            self.setLoading(false)
        }
    }
    
    deinit {
        viewModel.sections.remove(subscriber: "viewModel.sections")
    }
    // MARK: - Methods

    private func setDelegate() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func setupConstraints() {
        view.addSubview(collectionView)
        view.addSubview(loadingView)
        view.backgroundColor = .white
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    @objc private func showARModule() {
        let viewController = ARViewController()
        viewController.hidesBottomBarWhenPushed = true
        viewController.navigationController?.navigationBar.isHidden = true
        navigationController?.pushViewController(viewController, animated: true)
    }

    private func setLoading(_ isLoading: Bool) {
        if isLoading {
            loadingView.startAnimating()
            collectionView.isHidden = true
        } else {
            loadingView.stopAnimating()
            collectionView.isHidden = false
        }
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
        navigationItem.rightBarButtonItems = [arBarButtonItem]
    }
    
    func createTitleView(title: String, subtitle: String, image: String = "CARINCASA_logo") -> UIView {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: 280, height: 41)
        
        let logoImage = UIImageView()
        logoImage.image = UIImage(named: image)
        logoImage.frame = CGRect(x: 5, y: 0, width: 40, height: 40)
        logoImage.contentMode = .scaleAspectFill
        logoImage.clipsToBounds = true
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.frame = CGRect(x: 55, y: 0, width: 220, height: 20)
        titleLabel.font = UIFont(name: "FuturaPT-Medium", size: 20)
        titleLabel.textColor =  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        let descriptionLabel = UILabel()
        descriptionLabel.text = subtitle
        descriptionLabel.frame = CGRect(x: 55, y: 21, width: 220, height: 20)
        descriptionLabel.font = UIFont(name: "FuturaPT-Light", size: 16)
        descriptionLabel.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        
        view.addSubview(logoImage)
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        return view
    }
    
    func createBarButtonItem(title: String, selector: Selector) -> UIBarButtonItem {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.tintColor = .white
        button.imageView?.contentMode = .scaleAspectFit
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.addTarget(self, action: selector, for: .touchUpInside)
        return UIBarButtonItem(customView: button)
    }
}

// MARK: - ConfiguratorCellDelegate

extension ProductViewController: ConfiguratorCellDelegate {
    func update(configuration: ConfigurationModel) {
        if let configurationIndex = viewModel.configurations.firstIndex(where: { $0.title == configuration.title }) {
            viewModel.configurations[configurationIndex] = configuration
        }
        viewModel.totalSum = viewModel.configurations.map({ $0.options }).flatMap({ $0 }).filter({ $0.isSelected }).map({ Int($0.price) ?? 0 }).reduce(0, +)
        viewModel.updateSections()
        collectionView.reloadData()
    }
}

// MARK: - Create Layout

extension ProductViewController {
    private func createLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            guard let self = self else { return nil }
            let section = self.viewModel.sections.value[sectionIndex]
            switch section {
            case .product(_):
                return self.createProductSection()
            case .description(_):
                return self.createDescriptionSection()
            case .configuratorDescription(_):
                return self.createConfiguratorDescriptionSection()
            case let .configurator(configuration):
                let heights = self.findHeight(configuration: configuration)
                return self.createConfiguratorSection(heights: heights)
            case .price(_):
                return self.createPriceSection()
            case .order(_):
                return self.createOrderSection()
            }
        }
    }
    
    private func findHeight(configuration: [ConfigurationModel]) -> [Double] {
        var result: [Double] = []
        for i in 0..<configuration.count {
            let collectionHeight = 50.0 * Double(configuration[i].options.count) + 10.0 * Double((configuration[i].options.count - 1))
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
        section.boundarySupplementaryItems = [supplementaryHeaderItem(height: 5)]
        section.supplementaryContentInsetsReference = .automatic
        return section
    }
    
    private func createDescriptionSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                            heightDimension: .fractionalHeight(1)))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(0.975),
                                                                         heightDimension: .fractionalHeight(0.3)),
                                                       subitems: [item])
        return createCollectionLayoutSection(group: group)
    }
    
    private func createConfiguratorDescriptionSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                            heightDimension: .fractionalHeight(1)))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(0.975),
                                                              heightDimension: .estimated(80)),
                                                       subitems: [item])
        return createCollectionLayoutSection(group: group)
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
        return createCollectionLayoutSection(group: group)
    }
    
    private func createPriceSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                            heightDimension: .fractionalHeight(1)))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(0.975),
                                                              heightDimension: .fractionalHeight(0.1)),
                                                       subitems: [item])
        return createCollectionLayoutSection(group: group)
    }
    
    private func createOrderSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                            heightDimension: .fractionalHeight(1)))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(0.975),
                                                                         heightDimension: .estimated(70)),
                                                       subitems: [item])
        return createCollectionLayoutSection(group: group)
    }

    private func createCollectionLayoutSection(group: NSCollectionLayoutGroup) -> NSCollectionLayoutSection {
        group.edgeSpacing = .init(leading: .fixed(5), top: .fixed(0), trailing: .fixed(5), bottom: .fixed(0))
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .none
        section.interGroupSpacing = 5
        section.boundarySupplementaryItems = [supplementaryHeaderItem(height: 5)]
        section.supplementaryContentInsetsReference = .automatic
        return section
    }
    
    private func supplementaryHeaderItem(height: Double) -> NSCollectionLayoutBoundarySupplementaryItem {
            return .init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(height)),
                  elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
    }
}

// MARK: - UICollectionViewDataSource

extension ProductViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        viewModel.sections.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.sections.value[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch viewModel.sections.value[indexPath.section] {
        case let .product(product):
            let cell: ProductViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
            cell.configure(imageName: product[indexPath.row], name: viewModel.furniture?.name)
            return cell

        case let .description(description):
            let cell: DescriptionCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
            cell.configure(titles: description[indexPath.row])
            return cell

        case let .configuratorDescription(configuratorDesc):
            let cell: СonfiguratorDescriptionCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
            cell.configure(title: configuratorDesc[indexPath.row][0], subtitle: configuratorDesc[indexPath.row][1])
            return cell

        case let .configurator(configurator):
            let cell: ConfiguratorCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
            if configurator[indexPath.row].title == "ДОПОЛНИТЕЛЬНЫЕ ОПЦИИ" {
                cell.configure(title: configurator[indexPath.row].title,
                               configuration: configurator[indexPath.row],
                               multipleSelection: true)
                cell.delegate = self
            } else {
                cell.configure(title: configurator[indexPath.row].title,
                               configuration: configurator[indexPath.row],
                               multipleSelection: false)
                cell.delegate = self
            }
            return cell
            
        case let .price(price):
            let cell: PriceCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
            cell.configure(title: price[indexPath.row][0], price: price[indexPath.row][1])
            return cell

        case let .order(order):
            let cell: OrderCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
            cell.configure(title: order[indexPath.row])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header: HeaderSupplementaryView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, forIndexPath: indexPath)
            header.configure(title: viewModel.sections.value[indexPath.section].title)
            return header
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch viewModel.sections.value[indexPath.section] {
        case .order(_):
            guard let furniture = viewModel.furniture else {
                return
            }
            let newOrder: [String: String] = ["collectionImage": furniture.collectionImage,
                                              "id": furniture.id]
            var arrayOfOrders = UserDefaults.standard.array(forKey: "userOrders") as? [[String: String]] ?? []
            arrayOfOrders.append(newOrder)
            UserDefaults.standard.set(arrayOfOrders, forKey: "userOrders")
            UserDefaults.standard.synchronize()
            
            
            let alertController = UIAlertController(title: "Успешный заказ",
                                                    message: "Ваш заказ был успешно оформлен.",
                                                    preferredStyle: .alert)
            alertController.view.tintColor = ColorPalette.goldGradientLight[1]
            let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                alertController.dismiss(animated: true, completion: nil)
            }

            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        default:
            return
        }
    }
}

