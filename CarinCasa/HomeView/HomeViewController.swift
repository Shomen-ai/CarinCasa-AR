import UIKit
import SDWebImage

// MARK: - HomeViewController
final class HomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(loadingView)
        loadingView.startAnimating()
        collectionView.isHidden = true
        DispatchQueue.main.async {
            APIManager.shared.fetchData { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let product):
                    let item: HomeSection = {
                        .products(product.furniture)
                    }()
                    self.sections.append(item)
                case .failure(let error):
                    print(error)
                }
            }
        }
        setupNavBar()
        navigationItem.titleView = createCustomTitleView(title: "CARIN CASA", subtitle: "КАТАЛОГ")
        navigationItem.rightBarButtonItems = [
            createCustomButton(imageName: "slider.horizontal.3",
                               selector: #selector(showMenu)),
            createCustomButton(imageName: "square.grid.2x2",
                               selector: #selector(changeGrid))
            ]
        setupConstraints()
        setDelegate()
        collectionView.collectionViewLayout = createLayout()
        
    }
    
    private var images: [UIImageView] = []
    private let collectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.backgroundColor = .white
        collectionView.bounces = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(ProductsCell.self, forCellWithReuseIdentifier: ProductsCell.identifier)
        collectionView.register(HeaderSupplementaryView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: HeaderSupplementaryView.identifier)
        collectionView.showsVerticalScrollIndicator = false
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
    
    private var sections: [HomeSection] = [] {
        didSet {
            DispatchQueue.main.async {
                self.loadingView.stopAnimating()
                self.collectionView.reloadData()
                self.collectionView.isHidden = false
            }
        }
    }

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
    
    @objc func showMenu() {
        let alertController = UIAlertController(title: "Категория", message: nil, preferredStyle: .actionSheet)
        
        let action1 = UIAlertAction(title: "Все изделия", style: .default) { _ in
            print("Все изделия button was tapped")
        }
        alertController.addAction(action1)
        action1.setValue(UIColor.black, forKey: "titleTextColor")
        
        let action2 = UIAlertAction(title: "Столы", style: .default) { _ in
            print("Столы button was tapped")
        }
        alertController.addAction(action2)
        action2.setValue(UIColor.black, forKey: "titleTextColor")
        
        let action3 = UIAlertAction(title: "Консоли и зеркала", style: .default) { _ in
            print("Консоли и зеркала button was tapped")
        }
        alertController.addAction(action3)
        action3.setValue(UIColor.black, forKey: "titleTextColor")
        
        let action4 = UIAlertAction(title: "Стулья", style: .default) { _ in
            print("Стулья button was tapped")
        }
        alertController.addAction(action4)
        action4.setValue(UIColor.black, forKey: "titleTextColor")
        
        let action5 = UIAlertAction(title: "Журнальные столики", style: .default) { _ in
            print("Журнальные столики button was tapped")
        }
        alertController.addAction(action5)
        action5.setValue(UIColor.black, forKey: "titleTextColor")
        
        let action6 = UIAlertAction(title: "Комоды", style: .default) { _ in
            print("Комоды button was tapped")
        }
        alertController.addAction(action6)
        action6.setValue(UIColor.black, forKey: "titleTextColor")
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel) { _ in
            // Обработка выбора отмены
        }
        alertController.addAction(cancelAction)
        cancelAction.setValue(UIColor.black, forKey: "titleTextColor")
        
        present(alertController, animated: true, completion: nil)
    }
    
    private var buttonClicked: Bool = false
    @objc func changeGrid(_ sender: UIButton!) {
        if buttonClicked == false {
            let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
                guard let self = self else { return nil }
                let section = self.sections[sectionIndex]
                switch section {
                case .products(_):
                    return self.createProductsSection(itemWidth: ((self.view.frame.width - 20.0)/2), itemHeight: 1,
                                                      groupWidth: (self.view.frame.width - 10.0), groupHeight: 0.3)
                }
            }
            
            collectionView.setCollectionViewLayout(layout, animated: true)
            sender.setImage(UIImage(systemName: "square"), for: .normal)
            buttonClicked = true
        } else if buttonClicked == true {
            let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
                guard let self = self else { return nil }
                let section = self.sections[sectionIndex]
                switch section {
                case .products(_):
                    return self.createProductsSection(itemWidth: (self.view.frame.width - 10.0), itemHeight: 1,
                                                      groupWidth: (self.view.frame.width - 10.0), groupHeight: 0.3)
                }
            }
            collectionView.setCollectionViewLayout(layout, animated: true) { [weak self] _ in
                self?.collectionView.setContentOffset(.zero, animated: true)
            }
            sender.setImage(UIImage(systemName: "square.grid.2x2"), for: .normal)
            buttonClicked = false
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
        
        let menuBarItem = UIBarButtonItem(customView: button)
        return menuBarItem
    }
}

// MARK: - Create Layout
extension HomeViewController {
    private func createLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            guard let self = self else { return nil }
            let section = self.sections[sectionIndex]
            switch section {
            case .products(_):
                return self.createProductsSection(itemWidth: (self.view.frame.width - 10.0), itemHeight: 1,
                                                  groupWidth: (self.view.frame.width - 10.0), groupHeight: 0.3)
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
    
// MARK: - UICollectionViewDelegate
extension HomeViewController: UICollectionViewDelegate {

}

// MARK: - UICollectionViewDataSource
extension HomeViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        sections.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        sections[section].count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch sections[indexPath.section] {
        case .products(let products):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductsCell.identifier, for: indexPath) as? ProductsCell
            else {
                return UICollectionViewCell()
            }
            if let imageURL = URL(string: "http://localhost:3000/image/\(products[indexPath.row].collectionImage).png") {
                cell.imageView.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "placeholder"))
                cell.configureCell(titleString: products[indexPath.row].name)
                return cell
            } else {
                cell.configureCell(titleString: products[indexPath.row].name)
                return cell
            }
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
        case .products(let product):
            let newVC = ProductViewController()
            newVC.hidesBottomBarWhenPushed = true
            newVC.identifier = product[indexPath.item].id
            self.navigationController?.pushViewController(newVC, animated: true)
        }
        
    }
}
