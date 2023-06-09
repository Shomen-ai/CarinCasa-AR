import UIKit

protocol ConfiguratorCellDelegate: AnyObject {
    func didTap(item: IndexPath, isSelected: Bool)
}

final class ConfiguratorCell: UICollectionViewCell {
    
    weak var delegate: ConfiguratorCellDelegate?

    var selectedItems: Set<IndexPath> = []
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .left
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.font = UIFont(name: "FuturaPT-Medium", size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(ConfiguratorSubCell.self, forCellWithReuseIdentifier: ConfiguratorSubCell.identifier)
        view.showsVerticalScrollIndicator = false
        view.allowsSelection = true
        return view
    }()
    
//    private var items: Configuration = Configuration(title: "", type: [], price: []) {
//        didSet {
//            collectionView.reloadData()
//            updateTotalSum()
//        }
//    }
    
    private var items: [ConfigureItems] = [] {
            didSet {
                collectionView.reloadData()
            }
        }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        setupCollectionView()
    }
    
    required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    
    func setupLayout() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
//        contentView.backgroundColor = .red
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            titleLabel.widthAnchor.constraint(equalToConstant: frame.width - 10),
            
            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
        ])
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
    }
    
//    public func configureCell(titleString: String, configurations: Configuration) {
//        titleLabel.text = titleString
//        items = configurations
//    }
    
    public func configureCell(titleString: String, configurations: [ConfigureItems]) {
            titleLabel.text = titleString
            items = configurations
        }
    private var totalSum: Int = 0
    
//    private func updateTotalSum() {
//        totalSum = 0
//
//        for indexPath in collectionView.indexPathsForSelectedItems ?? [] {
//            let priceString = items.price[indexPath.item]
//            if let price = Int(priceString) {
//                totalSum += price
//            }
//        }
//    }
}

extension ConfiguratorCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: contentView.frame.width - 10, height: 50)
        }
}

extension ConfiguratorCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        items.type.count
        items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ConfiguratorSubCell.identifier, for: indexPath) as? ConfiguratorSubCell
        else {
            return UICollectionViewCell()
        }
//        cell.configureCell(typeString: items.type[indexPath.item], priceString: items.price[indexPath.item])
        cell.configureCell(typeString: items[indexPath.item].title, priceString: items[indexPath.item].price)
        if selectedItems.contains(where: { $0 == indexPath }) {
            collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .top)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didTap(item: IndexPath(row: indexPath.row, section: self.tag), isSelected: true)
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        delegate?.didTap(item: IndexPath(row: indexPath.row, section: self.tag), isSelected: false)
    }
}


final class ConfiguratorSubCell: UICollectionViewCell {
    
    private let title: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.textAlignment = .left
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.font = UIFont(name: "FuturaPT-Light", size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let price: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.textAlignment = .right
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.font = UIFont(name: "FuturaPT-Light", size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        contentView.addSubview(title)
        contentView.addSubview(price)
        layer.cornerRadius = 10
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1
        NSLayoutConstraint.activate([
            title.centerYAnchor.constraint(equalTo: centerYAnchor),
            title.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            title.widthAnchor.constraint(equalToConstant: (frame.width - 10)*0.75),
            
            price.centerYAnchor.constraint(equalTo: centerYAnchor),
            price.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            price.widthAnchor.constraint(equalToConstant: (frame.width - 10)*0.25),
        ])
    }
    
    public func configureCell(typeString: String, priceString: String) {
        title.text = typeString
        if let formattedPriceString = priceString.formattedWithSpaceSeparator() {
            price.text = "от \(formattedPriceString)₽"
        } else {
            price.text = "от \(priceString)₽"
        }
    }
    
    override var isSelected: Bool {
        didSet {
            layer.borderWidth = isSelected ? 2 : 1
            layer.borderColor = isSelected ? UIColor.black.cgColor : UIColor.gray.cgColor
            self.title.textColor = isSelected ? .black : .darkGray
            self.price.textColor = isSelected ? .black : .darkGray
        }
    }
}
//
//final class ProductViewController: UIViewController {
//    
//    var selectedItems: Set<IndexPath> = []
//
//    let collectionView: UICollectionView = {
//        let collectionView = UICollectionView()
//        collectionView.delegate = self
//        collectionView.dataSource = self
//        return collectionView
//    }
//}
//extension ProductViewController: UICollectionViewDelegate, UICollectionViewDataSource {
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        1
//    }
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        3
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let tag = indexPath.row
//        let cell = ConfiguratorCell()
//        cell.delegate = self
//        cell.tag = tag
//        cell.selectedItems = selectedItems
//        return cell
//    }
//}
//
//extension ProductViewController: ConfiguratorCellDelegate {
//    func didTap(item: IndexPath, isSelected: Bool) {
//        if isSelected {
//            selectedItems.insert(item)
//        } else {
//            selectedItems.remove(item)
//        }
//    }
//}
//


//protocol ConfiguratorCellDelegate: AnyObject {
//    func didTap(item: IndexPath, isSelected: Bool)
//}
//
//final class ConfiguratorCell: UICollectionViewCell {
//
//    weak var delegate: ConfiguratorCellDelegate?
//
//    var selectedItems: Set<IndexPath> = []
//
//    let collectionView: UICollectionView = {
//        let collectionView = UICollectionView()
//        collectionView.delegate = self
//        collectionView.dataSource = self
//        return collectionView
//    }
//}
//
//extension ConfiguratorCell: UICollectionViewDelegate, UICollectionViewDataSource {
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        1
//    }
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        3
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = ConfiguratorSubCell()
//        cell.isSelected = selectedItems.contains(where: { $0 == indexPath })
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        delegate?.didTap(item: IndexPath(row: indexPath.row, section: self.tag), isSelected: true)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
//        delegate?.didTap(item: IndexPath(row: indexPath.row, section: self.tag), isSelected: false)
//    }
//}
//
//
//
//final class ConfiguratorSubCell: UICollectionViewCell {
//    override var isSelected: Bool {
//        didSet {
//
//        }
//    }
//}
