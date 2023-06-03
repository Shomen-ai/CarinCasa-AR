import UIKit

// MARK: - InfoViewController
final class InfoViewController: UIViewController {
    
    private let collectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.backgroundColor = .none
        collectionView.bounces = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(ProfileCell.self, forCellWithReuseIdentifier: ProfileCell.identifier)
        collectionView.register(OrdersCell.self, forCellWithReuseIdentifier: OrdersCell.identifier)
        collectionView.register(InfoCell.self, forCellWithReuseIdentifier: InfoCell.identifier)
        collectionView.register(HeaderSupplementaryView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: HeaderSupplementaryView.identifier)
        return collectionView
    }()
    
    private let sections = MockDataForInfoViewController.shared.pageData
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupConstraints()
        setDelegate()
        collectionView.collectionViewLayout = createLayout()
    }
}

// MARK: - Create Layout
extension InfoViewController {
    private func createLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            guard let self = self else { return nil }
            let section = self.sections[sectionIndex]
            switch section {
            case.profile(_):
                return self.createProfileSection()
            case .order(_):
                return self.createOrdersSection()
            case .info(_):
                return self.createInfoSection()
            }
        }
    }
    
    private func createProfileSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                            heightDimension: .fractionalHeight(1)))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                                       heightDimension: .estimated(75)),
                                                       subitems: [item])
        group.interItemSpacing = .flexible(5)
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .none
        section.interGroupSpacing = 5
        section.boundarySupplementaryItems = [self.supplementaryHeaderItem()]
        section.supplementaryContentInsetsReference = .automatic
        return section
    }
    
    private func createOrdersSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                            heightDimension: .fractionalHeight(1)))
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(0.3),
                                                                         heightDimension: .fractionalHeight(0.2)),
                                                     subitems: [item])
        group.interItemSpacing = .fixed(5)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 5
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsetsReference = .none
        section.boundarySupplementaryItems = [self.supplementaryHeaderItem()]
        section.supplementaryContentInsetsReference = .automatic
        return section
    }
    
    private func createInfoSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                            heightDimension: .fractionalHeight(1)))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                                       heightDimension: .estimated(75)),
                                                       subitems: [item])
        group.interItemSpacing = .flexible(5)
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .none
        section.interGroupSpacing = 5
        section.boundarySupplementaryItems = [self.supplementaryHeaderItem()]
        section.supplementaryContentInsetsReference = .automatic
        return section
    }
    
    private func supplementaryHeaderItem() -> NSCollectionLayoutBoundarySupplementaryItem {
        .init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(30)),
              elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
    }
}

// MARK: - UICollectionViewDelegate
extension InfoViewController: UICollectionViewDelegate {
    
}

// MARK: - UICollectionViewDataSource
extension InfoViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        sections[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch sections[indexPath.section] {
            
        case .profile(let profile):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileCell.identifier, for: indexPath) as? ProfileCell
            else {
                return UICollectionViewCell()
            }
            cell.configureCell(imageName: profile[indexPath.item].image,
                               titleString: profile[indexPath.item].title)
            return cell
            
        case .order(let order):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OrdersCell.identifier, for: indexPath) as? OrdersCell
            else {
                return UICollectionViewCell()
            }
            cell.configureCell(imageName: order[indexPath.item].orderImage)
            return cell
            
        case .info(let info):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InfoCell.identifier, for: indexPath) as? InfoCell
            else {
                return UICollectionViewCell()
            }
            cell.configureCell(imageName: info[indexPath.item].image,
                               titleString: info[indexPath.item].title)
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
        case .profile(_):
            let newVC = ProductViewController()
            self.navigationController?.pushViewController(newVC, animated: true)
        case .order(_):
            let newVC = ProductViewController()
            self.navigationController?.pushViewController(newVC, animated: true)
        case .info(_):
            let newVC = ProductViewController()
            self.navigationController?.pushViewController(newVC, animated: true)
        }
            
    }
}
