import UIKit

final class OrderCell: UICollectionViewCell {

    // MARK: - UI Components

    private let titleLabel: UILabel = {
        let view = UILabel()
        view.textColor = .white
        view.textAlignment = .center
        view.font = UIFont(name: "FuturaPT-Medium", size: 20)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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

    // MARK: - Methods

    func setupLayout() {
        contentView.addSubview(titleLabel)
        contentView.backgroundColor = .black
        contentView.layer.cornerRadius = 25
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

    func configure(title: String) {
        titleLabel.text = title
    }
}
