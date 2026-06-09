//
//  TeamNameTransformer.swift
//  Realscore
//

import Foundation

enum TeamNameTransformer {
    static func transform(
        _ value: String?,
        option: TeamNameOption = .long
    ) -> String {
        guard let value, !value.isEmpty else {
            return ""
        }

        switch option {
            case .abbreviation:
                return AbbreviationTeamNames.values[value] ?? value
            case .short:
                return ShortTeamNames.values[value] ?? value
            case .long:
                return LongTeamNames.values[value] ?? value
        }
    }
}
