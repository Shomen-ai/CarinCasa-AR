import UIKit

final class DescriptionCell: UICollectionViewCell {
    
    private let titleLabel: UILabel = {
        let view = UILabel()
        view.textColor = .black
        view.textAlignment = .left
        view.font = UIFont.systemFont(ofSize: 16)
        view.numberOfLines = 0
        view.lineBreakMode = .byWordWrapping
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    func setupLayout() {
        contentView.addSubview(titleLabel)
//        contentView.backgroundColor = .red
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configureCell(titleString: [String]) {
        if let firstFont = UIFont(name: "FuturaPT-Medium", size: 18), let secondFont = UIFont(name: "FuturaPT-Light", size: 16) {
            let firstAttributes: [NSAttributedString.Key: Any] = [
                NSAttributedString.Key.font: firstFont
            ]
            
            let secondAttributes: [NSAttributedString.Key: Any] = [
                NSAttributedString.Key.font: secondFont
            ]
            
            let attributedString = NSMutableAttributedString()
                    
                    for (index, string) in titleString.enumerated() {
                        // Применение соответствующих атрибутов к каждой строке
                        let attributes = (index == 0) ? firstAttributes : secondAttributes
                        let attributedSubstring = NSAttributedString(string: string, attributes: attributes)
                        
                        attributedString.append(attributedSubstring)
                        
                        // Вставка \n\n между строками, кроме последней
                        if index < titleString.count - 1 {
                            attributedString.append(NSAttributedString(string: "\n\n"))
                        }
                    }
            
            titleLabel.attributedText = attributedString
        } else {
            titleLabel.font = UIFont(name: "FuturaPT-Light", size: 16)
            titleLabel.text = titleString.reduce("") { (result, string) -> String in
                if result.isEmpty {
                    return string
                } else {
                    return result + "\n\n" + string
                }
            }
        }
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let targetSize = CGSize(width: layoutAttributes.frame.width, height: UIView.layoutFittingCompressedSize.height)
        layoutAttributes.frame.size = contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
        return layoutAttributes
    }
}

