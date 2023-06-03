import Foundation

extension String {
    func formattedWithSpaceSeparator() -> String? {
        if let number = Int(self) {
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            numberFormatter.groupingSeparator = " "
            numberFormatter.groupingSize = 3
            return numberFormatter.string(from: NSNumber(value: number))
        }
        return nil
    }
}
