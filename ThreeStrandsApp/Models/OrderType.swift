import Foundation

enum OrderType: String, Codable, CaseIterable, Identifiable {
    case pickup
    case delivery

    var id: String { rawValue }

    var displayTitle: String {
        switch self {
        case .pickup: return "Pick up"
        case .delivery: return "Delivery"
        }
    }

    var systemImageName: String {
        switch self {
        case .pickup: return "takeoutbag.and.cup.and.straw"
        case .delivery: return "bicycle"
        }
    }

    var datePickerLabel: String {
        switch self {
        case .pickup: return "Pick up time"
        case .delivery: return "Delivery time"
        }
    }

    var dateFormatStyle: Date.FormatStyle {
        Date.FormatStyle(date: .abbreviated, time: .shortened)
    }

    func dateRange(reference: Date) -> PartialRangeFrom<Date> {
        switch self {
        case .pickup:
            return reference...
        case .delivery:
            return Date()...
        }
    }
}
