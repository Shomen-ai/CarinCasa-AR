import UIKit

final class OrderCell: UICollectionViewCell {
        
    private let titleLabel: UILabel = {
        let view = UILabel()
        view.textColor = .white
        view.textAlignment = .center
        view.font = UIFont(name: "FuturaPT-Medium", size: 20)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    func setupLayout() {
        contentView.addSubview(titleLabel)
        contentView.backgroundColor = .black
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configureCell(titleString: String) {
        titleLabel.text = titleString
    }
}
