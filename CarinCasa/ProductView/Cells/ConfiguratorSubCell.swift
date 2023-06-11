import UIKit

// MARK: - ConfiguratorSubCell

final class ConfiguratorSubCell: UICollectionViewCell {

    // MARK: - Properties

    override var isSelected: Bool {
        didSet {
            layer.borderWidth = isSelected ? 2 : 1
            layer.borderColor = isSelected ? UIColor.black.cgColor : UIColor.gray.cgColor
            title.textColor = isSelected ? .black : .darkGray
            price.textColor = isSelected ? .black : .darkGray
        }
    }

    // MARK: - UI Components

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

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        title.text = nil
        price.text = nil
        isSelected = false
    }

    // MARK: - Methods

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

    func configure(option: Option) {
        title.text = option.type
        if let priceString = option.price.formattedWithSpaceSeparator() {
            price.text = "от \(priceString)₽"
        } else {
            price.text = "от - ₽"
        }
        isSelected = option.isSelected
    }
}
