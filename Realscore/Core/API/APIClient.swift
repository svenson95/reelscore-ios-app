//
//  APIClient.swift
//  Realscore
//

import Foundation

enum APIClientError: LocalizedError {
    case badStatusCode(Int, String)
    case invalidResponse
    case decodingFailed(String)

    var errorDescription: String? {
        switch self {
        case .badStatusCode(let code, let body):
            return "HTTP Fehler \(code): \(body)"
        case .invalidResponse:
            return "Ungültige Server-Antwort."
        case .decodingFailed(let message):
            return message
        }
    }
}

final class APIClient {
    static let shared = APIClient()

    private init() {}

    func get<T: Decodable>(_ url: URL) async throws -> T {
        print("🌍 GET:", url.absoluteString)

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIClientError.invalidResponse
        }

        let body = String(data: data, encoding: .utf8) ?? ""

        print("📡 Status:", httpResponse.statusCode)

        guard (200...299).contains(httpResponse.statusCode) else {
            throw APIClientError.badStatusCode(httpResponse.statusCode, body)
        }

        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch DecodingError.keyNotFound(let key, let context) {
            let path = context.codingPath.map(\.stringValue).joined(separator: " -> ")
            let message = """
            Missing key: \(key.stringValue)
            Path: \(path)
            Debug: \(context.debugDescription)
            """
            print("❌", message)
            throw APIClientError.decodingFailed(message)
        } catch DecodingError.typeMismatch(let type, let context) {
            let path = context.codingPath.map(\.stringValue).joined(separator: " -> ")
            let message = """
            Type mismatch: \(type)
            Path: \(path)
            Debug: \(context.debugDescription)
            """
            print("❌", message)
            throw APIClientError.decodingFailed(message)
        } catch DecodingError.valueNotFound(let type, let context) {
            let path = context.codingPath.map(\.stringValue).joined(separator: " -> ")
            let message = """
            Value not found: \(type)
            Path: \(path)
            Debug: \(context.debugDescription)
            """
            print("❌", message)
            throw APIClientError.decodingFailed(message)
        } catch DecodingError.dataCorrupted(let context) {
            let path = context.codingPath.map(\.stringValue).joined(separator: " -> ")
            let message = """
            Data corrupted
            Path: \(path)
            Debug: \(context.debugDescription)
            """
            print("❌", message)
            throw APIClientError.decodingFailed(message)
        } catch {
            print("❌ Decode error:", error)
            throw APIClientError.decodingFailed(error.localizedDescription)
        }
    }
}
