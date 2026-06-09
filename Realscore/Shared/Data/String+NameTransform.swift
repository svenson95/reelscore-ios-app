//
//  String+NameTransform.swift
//  Realscore
//

import Foundation

enum TeamNameOption {
    case abbreviation
    case short
    case long
}

extension String {
    func teamName(_ option: TeamNameOption = .long) -> String {
        TeamNameTransformer.transform(self, option: option)
    }

    func competitionName() -> String {
        CompetitionNameTransformer.transform(self)
    }

    func roundLabel(
        competitionId: CompetitionId,
        season: Int,
        option: RoundLabelType = .standard
    ) -> String {
        RoundLabelTransformer.transform(
            self,
            context: RoundLabelContext(
                id: competitionId,
                season: season
            ),
            option: option
        )
    }
}
