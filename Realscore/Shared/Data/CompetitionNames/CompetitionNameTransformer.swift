//
//  CompetitionNameTransformer.swift
//  Realscore
//

import Foundation

enum CompetitionNameTransformer {
    static func transform(_ value: String?) -> String {
        guard let value, !value.isEmpty else {
            return ""
        }

        return CompetitionNameMap.values[value] ?? value
    }
}
