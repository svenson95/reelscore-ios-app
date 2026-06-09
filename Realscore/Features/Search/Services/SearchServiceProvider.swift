//
//  SearchServiceProvider.swift
//  Realscore
//

import Foundation

protocol SearchServiceProvider {
    func search(by query: String) async throws -> [SearchResult]
}
