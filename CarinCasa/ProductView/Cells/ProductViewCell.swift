import UIKit

final class ProductViewCell: UICollectionViewCell {

    // MARK: - UI Components

    private let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
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
        contentView.addSubview(imageView)
//        contentView.backgroundColor = .red
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }

    func configure(imageName: String, name: String?) {
        if let newName = name {
            imageView.sd_setImage(
                with: URL(string: "https://carincasa.na4u.ru/data/\(newName.replacingOccurrences(of: " ", with: "%20"))/\(imageName).png"),
                placeholderImage: UIImage(named: "placeholder")
            )
        } else {
            imageView.image = UIImage(named: "placeeholder")
        }
    }
}
