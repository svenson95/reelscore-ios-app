//
//  SearchType+Display.swift
//  Realscore
//

import Foundation

extension SearchType {
    var label: String {
        switch self {
        case .fixtures:
            return "Spiele"
        case .competitions:
            return "Wettbewerbe"
        case .teams:
            return "Teams"
        }
    }
}
