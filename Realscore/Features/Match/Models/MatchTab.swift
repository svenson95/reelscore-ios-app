//
//  MatchTab.swift
//  Realscore
//

enum MatchTab: String, CaseIterable {
    case details = "Details"
    case analyses = "Analyses"
    case events = "Events"
    case statistics = "Statistics"
    
    var systemImage: String {
        switch self {
        case .details:
            return "info.circle.fill"
        case .analyses:
            return "magnifyingglass.circle.fill"
        case .events:
            return "text.justify.leading"
        case .statistics:
            return "list.clipboard"
        }
    }
}
