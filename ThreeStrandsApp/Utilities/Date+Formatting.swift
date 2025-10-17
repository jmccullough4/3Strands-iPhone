import Foundation

extension Date {
    func formattedRelativeEventRange(endDate: Date) -> String {
        let formatter = DateIntervalFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: self, to: endDate)
    }
}
