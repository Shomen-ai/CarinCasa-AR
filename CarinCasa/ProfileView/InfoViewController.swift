import UIKit

// MARK: - InfoViewController

final class InfoViewController: UIViewController {
    
    // MARK: - UI Components
    
    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        collectionView.backgroundColor = .white
        collectionView.bounces = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(ProfileCell.self)
        collectionView.register(OrdersCell.self)
        collectionView.register(InfoCell.self)
        collectionView.register(HeaderSupplementaryView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader)
        collectionView.register(EmptySectionDecorationItem.self,
                                forSupplementaryViewOfKind: "emptySectionBackground")
        return collectionView
    }()
    
    // MARK: - Properties
    
    private let viewModel: InfoViewModelProtocol
    
    // MARK: - Life cycle
    
    init(viewModel: InfoViewModelProtocol) {
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
        setupNavBar()
        navigationItem.titleView = createCustomTitleView(title: "CARIN CASA", subtitle: "ИНФОРМАЦИЯ")
        setupConstraints()
        setDelegate()
        collectionView.collectionViewLayout = createLayout()
        collectionView.collectionViewLayout.register(EmptySectionDecorationItem.self,
                                                     forDecorationViewOfKind: "emptySectionBackground")
        
        viewModel.sections.add(subscriber: "viewModel.sections") { [weak self] old, new in
            guard let self = self else {
                return
            }
            DispatchQueue.main.async { [weak self] in
                self?.collectionView.reloadData()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.updateSection()
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
        view.backgroundColor = ColorPalette.backgrounColor
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    
}
// MARK: - Setup NavBar

extension InfoViewController {
    private func setupNavBar() {
        navigationController?.navigationBar.barTintColor = .black
        navigationController?.navigationBar.backgroundColor = .black
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
            view.frame = CGRect(x: 55, y: 0, width: 220, height: 20)
            view.textColor =  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            return view
        }()
        
        if let firstFont = UIFont(name: "FuturaPT-Medium", size: 20), let secondFont = UIFont(name: "FuturaPT-Light", size: 20) {
            let firstAttributes: [NSAttributedString.Key: Any] = [
                NSAttributedString.Key.font: firstFont
            ]
            
            let secondAttributes: [NSAttributedString.Key: Any] = [
                NSAttributedString.Key.font: secondFont
            ]
            
            let attributedString = NSMutableAttributedString(string: title)
            attributedString.addAttributes(firstAttributes, range: NSRange(location: 0, length: 5))
            attributedString.addAttributes(secondAttributes, range: NSRange(location: 6, length: 4))
            
            titleLabel.attributedText = attributedString
        } else {
            titleLabel.font = UIFont(name: "FuturaPT-Medium", size: 20)
            titleLabel.text = title
        }
        let descriptionLabel: UILabel = {
            let view = UILabel()
            view.text = subtitle
            view.frame = CGRect(x: 55, y: 21, width: 220, height: 20)
            view.font = UIFont(name: "FuturaPT-Light", size: 14)
            view.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            return view
        }()
        
        view.addSubview(logoImage)
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        
        return view
    }
}

// MARK: - Create Layout
extension InfoViewController {
    private func createLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            guard let self = self else { return nil }
            let section = self.viewModel.sections.value[sectionIndex]
            switch section {
            case.profile(_):
                return self.createProfileSection()
            case .order(let orders):
                return self.createOrdersSection(itemsCount: orders.count)
            case .info(_):
                return self.createInfoSection()
            }
        }
    }
    
    private func createProfileSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                            heightDimension: .fractionalHeight(1)))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .absolute(view.frame.width-10),
                                                                       heightDimension: .estimated(50)),
                                                       subitems: [item])
        group.interItemSpacing = .fixed(10)
        group.edgeSpacing = .init(leading: .fixed(5), top: .fixed(10), trailing: .fixed(5), bottom: .fixed(0))
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .none
        section.interGroupSpacing = 5
        section.boundarySupplementaryItems = [self.supplementaryHeaderItem(height: 0.1)]
        section.supplementaryContentInsetsReference = .automatic
        return section
    }
    
    private func createOrdersSection(itemsCount: Int) -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                            heightDimension: .fractionalHeight(1)))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(0.3),
                                                                         heightDimension: .fractionalHeight(0.2)),
                                                     subitems: [item])
        group.interItemSpacing = .fixed(5)
        group.edgeSpacing = .init(leading: .fixed(0), top: .fixed(5), trailing: .fixed(5), bottom: .fixed(0))
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 5
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsetsReference = .none
        section.boundarySupplementaryItems = [self.supplementaryHeaderItem(height: 30)]
        section.supplementaryContentInsetsReference = .automatic
        
        if itemsCount == 0 {
            let decorationItem = NSCollectionLayoutDecorationItem.background(elementKind: "emptySectionBackground")
            section.decorationItems = [decorationItem]
        }
        
        return section
    }
    
    private func createInfoSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                            heightDimension: .fractionalHeight(1)))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .absolute(view.frame.width-10),
                                                                       heightDimension: .estimated(50)),
                                                       subitems: [item])
        group.interItemSpacing = .fixed(5)
        group.edgeSpacing = .init(leading: .fixed(5), top: .fixed(10), trailing: .fixed(5), bottom: .fixed(0))
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .none
        section.interGroupSpacing = 5
        section.boundarySupplementaryItems = [self.supplementaryHeaderItem(height: 10)]
        section.supplementaryContentInsetsReference = .automatic
        return section
    }
    
    private func supplementaryHeaderItem(height: Double) -> NSCollectionLayoutBoundarySupplementaryItem {
        return .init(
            layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(height)),
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension InfoViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        viewModel.sections.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.sections.value[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch viewModel.sections.value[indexPath.section] {
        case let .profile(profile):
            let cell: ProfileCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
            cell.configure(imageName: profile[indexPath.item].image, title: profile[indexPath.item].title)
            return cell
            
        case let .order(order):
            let cell: OrdersCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
            cell.configure(imageName: order[indexPath.item].orderImage)
            return cell
            
        case let .info(info):
            let cell: InfoCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
            cell.configure(imageName: info[indexPath.item].image, title: info[indexPath.item].title)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header: HeaderSupplementaryView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, forIndexPath: indexPath)
            header.configure(title: viewModel.sections.value[indexPath.section].title)
            return header
        }
        if kind == "emptySectionBackground" {
                let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "EmptySectionDecorationItem", for: indexPath)
                // Настройте вашу декоративную вью, например, установите фон или текст
                return view
            }
        return UICollectionReusableView()
    }
}
