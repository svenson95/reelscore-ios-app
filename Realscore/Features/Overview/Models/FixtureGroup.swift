//
//  FixtureGroup.swift
//  Realscore
//

struct FixtureGroupKey: Hashable {
    let competition: String
    let round: String
}

struct FixtureSectionGroup: Identifiable {
    let competition: String
    let competitionLogo: String?
    let round: String
    let fixtures: [Fixture]

    var id: String {
        "\(competition)-\(round)"
    }
}
