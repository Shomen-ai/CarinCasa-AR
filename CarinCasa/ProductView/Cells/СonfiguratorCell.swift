import UIKit

// MARK: - ConfiguratorCellDelegate

protocol ConfiguratorCellDelegate: AnyObject {
    func update(configuration: ConfigurationModel)
}

// MARK: - ConfiguratorCell

final class ConfiguratorCell: UICollectionViewCell {

    // MARK: - Properties
    
    weak var delegate: ConfiguratorCellDelegate?

    private var configuration: ConfigurationModel = ConfigurationModel(title: "", options: []) {
        didSet {
            collectionView.reloadData()
            configuration.options.enumerated().forEach {
                if $1.isSelected {
                    collectionView.selectItem(at: IndexPath(row: $0, section: 0), animated: true, scrollPosition: .left)
                }
            }
        }
    }

    // MARK: - UI Components
    
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
        view.register(ConfiguratorSubCell.self)
        view.showsVerticalScrollIndicator = false
        view.allowsSelection = true
        view.allowsMultipleSelection = true
        return view
    }()

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        setupCollectionView()
        print(collectionView.allowsMultipleSelection)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods
    
    private func setupLayout() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(collectionView)
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
    
    func configure(title: String, configuration: ConfigurationModel, multipleSelection: Bool) {
        titleLabel.text = title
        self.configuration = configuration
        collectionView.allowsMultipleSelection = multipleSelection
    }
}

extension ConfiguratorCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: contentView.frame.width - 10, height: 50)
    }
}

extension ConfiguratorCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        configuration.options.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ConfiguratorSubCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        cell.configure(option: configuration.options[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        configuration.options[indexPath.row].isSelected = true
        print("didSelectItemAt", configuration.options[indexPath.row])
        delegate?.update(configuration: configuration)
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        configuration.options[indexPath.row].isSelected = false
        print("didDeselectItemAt", configuration.options[indexPath.row])
        delegate?.update(configuration: configuration)
    }
}
