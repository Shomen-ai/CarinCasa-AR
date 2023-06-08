import UIKit

final class ProductViewCell: UICollectionViewCell {
    
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configureCell(imageName: String, name: String) {
        imageView.image = UIImage(named: imageName)
        self.imageView.sd_setImage(with: URL(string: "http://localhost:3000/data/\(name.replacingOccurrences(of: " ", with: "%20"))/\(imageName).png"),
                                   placeholderImage: UIImage(named: "placeholder"))
    }
}
