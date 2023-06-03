import UIKit

extension UICollectionViewCell {
    public class var identifier: String {
        return "\(self.self)"
    }
}

extension UITableViewCell {
    public class var identifier: String {
        return "\(self.self)"
    }
}
