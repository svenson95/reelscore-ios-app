//
//  RoundLabelTranslation.swift
//  Realscore
//

import Foundation

struct RoundLabelTranslation {
    let standard: String
    let header: String

    func label(for type: RoundLabelType) -> String {
        switch type {
        case .standard:
            return standard
        case .header:
            return header
        }
    }
}

typealias RoundLabelFactory = (String) -> RoundLabelTranslation
typealias RoundMap = [String: RoundLabelFactory]
typealias RoundMapOverride = [String: RoundLabelFactory]
