import UIKit

final class HeaderSupplementaryView: UICollectionReusableView {
    
    public class var identifier: String {
        return "\(self.self)"
    }
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.text = "Header"
        label.textAlignment = .left
        label.font = UIFont(name: "FuturaPT-Light", size: 16)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        addSubview(headerLabel)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            headerLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
        ])
    }
    
    func configureHeader(titleString: String) {
        headerLabel.text = titleString
    }
}
