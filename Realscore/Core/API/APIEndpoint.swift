//
//  APIEndpoint.swift
//  Realscore
//

import Foundation

enum APIEndpoint {
    case fixturesByDate(date: String)
    case search(query: String)

    var path: String {
        switch self {
        case .fixturesByDate:
            return "/fixtures/by-date"
        case .search:
            return "/search"
        }
    }

    var queryItems: [URLQueryItem] {
        switch self {
        case .fixturesByDate(let date):
            return [URLQueryItem(name: "date", value: date)]
        case .search(let query):
            return [URLQueryItem(name: "q", value: query)]
        }
    }

    var url: URL {
        var components = URLComponents(url: Constants.baseURL.appending(path: path), resolvingAgainstBaseURL: false)!
        components.queryItems = queryItems.isEmpty ? nil : queryItems
        return components.url!
    }
}
