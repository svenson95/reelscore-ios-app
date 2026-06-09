//
//  TimeZone+Extension.swift
//  Realscore
//

import Foundation

extension TimeZone {
    static let appTimeZone = TimeZone(identifier: "Europe/Berlin") ?? .current
}
