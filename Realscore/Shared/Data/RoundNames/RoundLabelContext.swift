//
//  RoundLabelContext.swift
//  Realscore
//

import Foundation

struct RoundLabelContext {
    let id: Int
    let season: Int
    let type: RoundLabelType

    init(
        id: Int,
        season: Int,
        type: RoundLabelType = .standard
    ) {
        self.id = id
        self.season = season
        self.type = type
    }
}
