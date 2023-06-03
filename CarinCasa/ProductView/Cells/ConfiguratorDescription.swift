import UIKit

final class СonfiguratorDescriptionCell: UICollectionViewCell {
    
    private let configurator: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .left
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let configuratorDescription: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .left
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    func setupLayout() {
        contentView.addSubview(configurator)
        contentView.addSubview(configuratorDescription)
//        contentView.backgroundColor = .red
        NSLayoutConstraint.activate([
            configurator.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            configurator.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            configurator.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            configurator.widthAnchor.constraint(equalToConstant: frame.width - 10),
            
            configuratorDescription.topAnchor.constraint(equalTo: configurator.bottomAnchor, constant: 10),
            configuratorDescription.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            configuratorDescription.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            configuratorDescription.widthAnchor.constraint(equalToConstant: frame.width - 10)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configureCell(titleString: String, subTitleString: String) {
        configurator.text = titleString
        configuratorDescription.text = subTitleString
    }
}
