//
//  Constants.swift
//  Realscore
//

import Foundation

enum Constants {
    static let baseURL = URL(string: "https://reelscore-api-svenson95s-projects.vercel.app")!

    static let firstSupportedSeason = 2023
    
    static let firstRealWeekdayIndex = 1
    static let lastRealWeekdayIndex = 7
    static let previousWeekEdgeIndex = 0
    static let nextWeekEdgeIndex = 8
    
    static let DATA_START_DATE = "2023-07-28"
    static let DATA_END_DATE = "2026-09-01"
}
