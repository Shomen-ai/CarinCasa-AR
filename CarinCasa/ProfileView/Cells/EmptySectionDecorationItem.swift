import UIKit

class EmptySectionDecorationItem: UICollectionReusableView {
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.text = "Пока у вас нет заказов..."
        label.textAlignment = .left
        label.font = UIFont(name: "FuturaPT-Light", size: 16)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let placeholderView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 25
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(placeholderView)
        placeholderView.addSubview(infoLabel)
        backgroundColor = .clear
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            placeholderView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            placeholderView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            placeholderView.topAnchor.constraint(equalTo: topAnchor, constant: 40),
            placeholderView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            
            infoLabel.centerYAnchor.constraint(equalTo: placeholderView.centerYAnchor),
            infoLabel.centerXAnchor.constraint(equalTo: placeholderView.centerXAnchor),
        ])
    }
}
