import UIKit

// MARK: - ReusableView

protocol ReusableView: AnyObject {
    static var defaultReuseIdentifier: String { get }
}

extension ReusableView where Self: UIView {
    static var defaultReuseIdentifier: String {
        String(describing: self)
    }
}

// MARK: - UITableViewCell + ReusableView

extension UITableViewCell: ReusableView {}

// MARK: - UITableViewHeaderFooterView + ReusableView

extension UITableViewHeaderFooterView: ReusableView {}

// MARK: - UICollectionReusableView + ReusableView

extension UICollectionReusableView: ReusableView {}

extension UICollectionViewFlowLayout {
    func register<T: UICollectionReusableView>(_: T.Type) {
        register(T.self, forDecorationViewOfKind: T.defaultReuseIdentifier)
    }

    func registerNib<T: UICollectionReusableView>(_: T.Type) {
        register(UINib(nibName: T.defaultReuseIdentifier, bundle: nil), forDecorationViewOfKind: T.defaultReuseIdentifier)
    }
}

extension UITableView {
    func register<T: UITableViewCell>(_: T.Type) {
        register(T.self, forCellReuseIdentifier: T.defaultReuseIdentifier)
    }

    func registerNib<T: UITableViewCell>(_: T.Type) {
        register(UINib(nibName: T.defaultReuseIdentifier, bundle: nil), forCellReuseIdentifier: T.defaultReuseIdentifier)
    }

    func register<T: UITableViewHeaderFooterView>(_: T.Type) {
        register(T.self, forHeaderFooterViewReuseIdentifier: T.defaultReuseIdentifier)
    }

    func registerNib<T: UITableViewHeaderFooterView>(_: T.Type) {
        register(UINib(nibName: T.defaultReuseIdentifier, bundle: nil), forHeaderFooterViewReuseIdentifier: T.defaultReuseIdentifier)
    }

    func dequeueReusableCell<T: UITableViewCell>(forIndexPath indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.defaultReuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.defaultReuseIdentifier)")
        }

        return cell
    }

    func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>() -> T {
        guard let cell = dequeueReusableHeaderFooterView(withIdentifier: T.defaultReuseIdentifier) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.defaultReuseIdentifier)")
        }

        return cell
    }
}

extension UICollectionView {
    func register<T: UICollectionViewCell>(_: T.Type) {
        register(T.self, forCellWithReuseIdentifier: T.defaultReuseIdentifier)
    }

    func registerNib<T: UITableViewCell>(_: T.Type) {
        register(UINib(nibName: T.defaultReuseIdentifier, bundle: nil), forCellWithReuseIdentifier: T.defaultReuseIdentifier)
    }

    func registerNib<T: UICollectionViewCell>(_: T.Type) {
        register(UINib(nibName: T.defaultReuseIdentifier, bundle: nil), forCellWithReuseIdentifier: T.defaultReuseIdentifier)
    }

    func dequeueReusableCell<T: UICollectionViewCell>(forIndexPath indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.defaultReuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.defaultReuseIdentifier)")
        }

        return cell
    }

    func register<T: UICollectionReusableView>(_: T.Type, forSupplementaryViewOfKind elementKind: String) {
        register(
            T.self,
            forSupplementaryViewOfKind: elementKind,
            withReuseIdentifier: T.defaultReuseIdentifier
        )
    }

    func registerNib<T: UICollectionReusableView>(_: T.Type, forSupplementaryViewOfKind elementKind: String) {
        register(
            UINib(nibName: T.defaultReuseIdentifier, bundle: nil),
            forSupplementaryViewOfKind: elementKind,
            withReuseIdentifier: T.defaultReuseIdentifier
        )
    }

    func dequeueReusableSupplementaryView<T: UICollectionReusableView>(ofKind elementKind: String, forIndexPath indexPath: IndexPath) -> T {
        guard let view = dequeueReusableSupplementaryView(
            ofKind: elementKind,
            withReuseIdentifier: T.defaultReuseIdentifier,
            for: indexPath
        ) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.defaultReuseIdentifier)")
        }

        return view
    }
}
