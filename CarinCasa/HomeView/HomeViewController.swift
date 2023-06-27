import UIKit
import SDWebImage

// MARK: - HomeViewController
final class HomeViewController: UIViewController {

    // MARK: - UI Components

    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        collectionView.backgroundColor = .white
        collectionView.bounces = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(ProductsCell.self)
        collectionView.register(HeaderSupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader)
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

    private lazy var showMenuBarButtonItem = createCustomButton(imageName: "slider.horizontal.3",
                                                                selector: #selector(showMenu))

    private lazy var changeGridBarButtonItem = createCustomButton(imageName: "square.grid.2x2",
                                                                  selector: #selector(changeGrid))

    // MARK: - Properties

    private var changeGridButtonClicked: Bool = false

    private let viewModel: HomeViewModelProtocol

    // MARK: - Lifecycle

    init(viewModel: HomeViewModelProtocol) {
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

        view.addSubview(loadingView)
        setLoading(true)

        setupNavBar()
        navigationItem.titleView = createCustomTitleView(title: "CARIN CASA", subtitle: "КАТАЛОГ")
        navigationItem.rightBarButtonItems = [
            showMenuBarButtonItem,
            changeGridBarButtonItem,
        ]
        setupConstraints()
        setDelegate()
        collectionView.collectionViewLayout = createLayout()

        viewModel.sections.add(subscriber: "viewModel.sections") { [weak self] old, new in
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
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
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
    
    @objc private func showMenu() {
        let alertController = UIAlertController(title: "Категория", message: nil, preferredStyle: .actionSheet)
        let actions: [UIAlertAction] = [
            UIAlertAction(title: "Все изделия", style: .default) { [weak self] _ in
                guard let self = self, let furniture = self.viewModel.furniture else { return }
                self.viewModel.sections.update(with: [.products(furniture)])
            },
            UIAlertAction(title: "Столы", style: .default) { [weak self] _ in
                guard let self = self, let furniture = self.viewModel.furniture else { return }
                self.viewModel.sections.update(with: [.products(furniture.filter {$0.type == "Стол"})])
            },
            UIAlertAction(title: "Консоли и зеркала", style: .default) { [weak self] _ in
                guard let self = self, let furniture = self.viewModel.furniture else { return }
                self.viewModel.sections.update(with: [.products(furniture.filter {$0.type == "Консоли и зеркала"})])
            },
            UIAlertAction(title: "Стулья", style: .default) { [weak self] _ in
                guard let self = self, let furniture = self.viewModel.furniture else { return }
                self.viewModel.sections.update(with: [.products(furniture.filter {$0.type == "Стулья"})])
            },
            UIAlertAction(title: "Журнальные столики", style: .default) { [weak self] _ in
                guard let self = self, let furniture = self.viewModel.furniture else { return }
                self.viewModel.sections.update(with: [.products(furniture.filter {$0.type == "Журнальные столики"})])
            },
            UIAlertAction(title: "Комоды", style: .default) { [weak self] _ in
                guard let self = self, let furniture = self.viewModel.furniture else { return }
                self.viewModel.sections.update(with: [.products(furniture.filter {$0.type == "Комоды"})])
            },
            UIAlertAction(title: "Отмена", style: .cancel) { _ in
                // Обработка выбора отмены
            },
        ]
        actions.forEach {
            alertController.addAction($0)
            $0.setValue(UIColor.black, forKey: "titleTextColor")
        }

        present(alertController, animated: true, completion: nil)
    }

    @objc private func changeGrid(_ sender: UIButton!) {
        if changeGridButtonClicked == false {
            let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
                guard let self = self else { return nil }
                let section = self.viewModel.sections.value[sectionIndex]
                switch section {
                case .products(_):
                    return self.createProductsSection(
                        itemWidth: ((self.view.frame.width - 20.0)/2),
                        itemHeight: 1,
                        groupWidth: (self.view.frame.width - 10.0),
                        groupHeight: 0.3
                    )
                }
            }

            collectionView.setCollectionViewLayout(layout, animated: true)
            sender.setImage(UIImage(systemName: "square"), for: .normal)
            changeGridButtonClicked = true
        } else {
            let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
                guard let self = self else { return nil }
                let section = self.viewModel.sections.value[sectionIndex]
                switch section {
                case .products(_):
                    return self.createProductsSection(
                        itemWidth: (self.view.frame.width - 10.0),
                        itemHeight: 1,
                        groupWidth: (self.view.frame.width - 10.0),
                        groupHeight: 0.3
                    )
                }
            }
            collectionView.setCollectionViewLayout(layout, animated: true) { [weak self] _ in
                self?.collectionView.setContentOffset(.zero, animated: true)
            }
            sender.setImage(UIImage(systemName: "square.grid.2x2"), for: .normal)
            changeGridButtonClicked = false
        }
    }
}

// MARK: - Setup NavigationBar
extension HomeViewController {
    private func setupNavBar() {
        navigationController?.navigationBar.barTintColor = .black
        navigationController?.navigationBar.backgroundColor = .black
        navigationController?.navigationBar.isTranslucent = false
    }

    func createCustomTitleView(title: String, subtitle: String, image: String = "CARINCASA_logo") -> UIView {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: 280, height: 41)

        let logoImage = UIImageView()
        logoImage.image = UIImage(named: image)
        logoImage.frame = CGRect(x: 5, y: 0, width: 40, height: 40)
        logoImage.contentMode = .scaleAspectFill
        logoImage.clipsToBounds = true

        let titleLabel = UILabel()
        titleLabel.frame = CGRect(x: 55, y: 0, width: 220, height: 20)
        titleLabel.textColor =  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)

        if let firstFont = UIFont(name: "FuturaPT-Medium", size: 20), let secondFont = UIFont(name: "FuturaPT-Light", size: 20) {
            let firstAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: firstFont]
            let secondAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: secondFont]

            let attributedString = NSMutableAttributedString(string: title)
            attributedString.addAttributes(firstAttributes, range: NSRange(location: 0, length: 5))
            attributedString.addAttributes(secondAttributes, range: NSRange(location: 6, length: 4))

            titleLabel.attributedText = attributedString
        } else {
            titleLabel.font = UIFont(name: "FuturaPT-Medium", size: 20)
            titleLabel.text = title
        }
        let descriptionLabel = UILabel()
        descriptionLabel.text = subtitle
        descriptionLabel.frame = CGRect(x: 55, y: 21, width: 220, height: 20)
        descriptionLabel.font = UIFont(name: "FuturaPT-Light", size: 14)
        descriptionLabel.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)

        view.addSubview(logoImage)
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        return view
    }

    func createCustomButton(imageName: String, selector: Selector) -> UIBarButtonItem {
        let button = UIButton(type: .system)
        button.setImage(
            UIImage(systemName: imageName)?.withRenderingMode(.alwaysTemplate),
            for: .normal
        )
        button.tintColor = .white
        button.imageView?.contentMode = .scaleAspectFit
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.addTarget(self, action: selector, for: .touchUpInside)
        return UIBarButtonItem(customView: button)
    }
}

// MARK: - Create Layout
extension HomeViewController {
    private func createLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            guard let self = self else { return nil }
            let section = self.viewModel.sections.value[sectionIndex]
            switch section {
            case .products(_):
                return self.createProductsSection(
                    itemWidth: (self.view.frame.width - 10.0),
                    itemHeight: 1,
                    groupWidth: (self.view.frame.width - 10.0),
                    groupHeight: 0.3
                )
            }
        }
    }

    private func createProductsSection(itemWidth: Double, itemHeight: Double,
                                       groupWidth: Double, groupHeight: Double) -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .absolute(itemWidth),
                                                            heightDimension: .fractionalHeight(itemHeight)))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .absolute(groupWidth),
                                                                       heightDimension: .fractionalHeight(groupHeight)),
                                                     subitems: [item, item])
        group.interItemSpacing = .fixed(10)
        group.edgeSpacing = .init(leading: .fixed(5), top: .fixed(0), trailing: .fixed(5), bottom: .fixed(15))
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

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        viewModel.sections.value.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.sections.value[section].count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch viewModel.sections.value[indexPath.section] {
        case let .products(products):
            let cell: ProductsCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
            if let imageURL = URL(string: "https://carincasa.na4u.ru/image/\(products[indexPath.row].collectionImage).png") {
                cell.imageView.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "placeholder"))
            }
            cell.configure(title: products[indexPath.row].name)
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
        case let .products(product):
            let viewController = ProductViewController(viewModel: ProductViewModel(productId: product[indexPath.item].id))
            viewController.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
}
