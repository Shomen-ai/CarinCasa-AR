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

extension String {
    func extractIntegerSubstring() -> Int {
        let substring = self.suffix(from: self.index(self.startIndex, offsetBy: 3)).prefix(self.count - 1 - 3)
        let trimmedString = substring.replacingOccurrences(of: " ", with: "")
        return Int(trimmedString) ?? 0
    }
}
