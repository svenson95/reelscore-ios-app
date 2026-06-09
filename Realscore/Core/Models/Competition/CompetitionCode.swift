//
//  CompetitionCode.swift
//  Realscore
//

import Foundation

enum CompetitionCode: String, CaseIterable, Identifiable {
    // Europa
    case europaUefaChampionsLeague = "EUROPA_UEFA_CHAMPIONS_LEAGUE"
    case europaUefaEuroLeague = "EUROPA_UEFA_EURO_LEAGUE"
    case europaUefaSuperCup = "EUROPA_UEFA_SUPER_CUP"

    // International
    case internationalEuroChampionship = "INTERNATIONAL_EURO_CHAMPIONSHIP"
    case internationalWorldCup = "INTERNATIONAL_WORLD_CUP"
    case internationalWorldCupQualificationConcacaf = "INTERNATIONAL_WORLD_CUP_QUALIFICATION_CONCACAF"
    case internationalWorldCupQualificationEurope = "INTERNATIONAL_WORLD_CUP_QUALIFICATION_EUROPE"
    case internationalUefaNationsLeague = "INTERNATIONAL_UEFA_NATIONS_LEAGUE"
    case internationalFriendlies = "INTERNATIONAL_FRIENDLIES"

    // Deutschland
    case germanyBundesliga = "GERMANY_BUNDESLIGA"
    case germanyBundesliga2 = "GERMANY_BUNDESLIGA_2"
    case germanySuperCup = "GERMANY_SUPER_CUP"
    case germanyDfbPokal = "GERMANY_DFB_POKAL"

    // England
    case englandPremierLeague = "ENGLAND_PREMIER_LEAGUE"
    case englandLeagueCup = "ENGLAND_LEAGUE_CUP"
    case englandFaCup = "ENGLAND_FA_CUP"
    case englandCommunityShield = "ENGLAND_COMMUNITY_SHIELD"

    // Spanien
    case spainLaLiga = "SPAIN_LA_LIGA"
    case spainSuperCup = "SPAIN_SUPER_CUP"
    case spainCopaDelRey = "SPAIN_COPA_DEL_REY"

    // Italien
    case italySerieA = "ITALY_SERIE_A"
    case italyCoppaItalia = "ITALY_COPPA_ITALIA"

    // Frankreich
    case franceLigue1 = "FRANCE_LIGUE_1"
    case franceCoupeDeFrance = "FRANCE_COUPE_DE_FRANCE"
    case franceTropheeDesChampions = "FRANCE_TROPHEE_DES_CHAMPIONS"

    // Niederlande
    case eredivisie = "EREDIVISIE"

    // USA
    case majorLeagueSoccer = "MAJOR_LEAGUE_SOCCER"

    var id: String {
        rawValue
    }
}

extension CompetitionCode {
    var apiId: CompetitionId {
        CompetitionMap.required(self).apiId // Type 'CompetitionMap' has no member 'required'
    }

    var name: CompetitionName {
        CompetitionMap.required(self).name // Type 'CompetitionMap' has no member 'required'
    }

    var url: CompetitionUrl {
        CompetitionMap.required(self).url // Type 'CompetitionMap' has no member 'required'
    }
}
