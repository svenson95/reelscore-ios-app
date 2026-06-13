//
//  VenueImageLoader.swift
//  Realscore
//

import SwiftUI
import UIKit
import Combine

@MainActor
final class VenueImageLoader: ObservableObject {
    @Published private(set) var image: UIImage?
    @Published private(set) var isLoaded = false
    @Published private(set) var hasValidVenueBackground = false

    private var currentTask: Task<Void, Never>?

    deinit {
        currentTask?.cancel()
    }

    func loadVenueImage(for venueId: VenueId?) {
        currentTask?.cancel()

        image = nil
        isLoaded = false
        hasValidVenueBackground = false

        currentTask = Task {
            let resolvedVenueId = venueId ?? VenueIds.DEFAULT_VALUE
            let loadedImage = await VenueImageLoader.loadValidImageWithFallback(
                venueId: resolvedVenueId
            )

            guard !Task.isCancelled else { return }

            image = loadedImage
            hasValidVenueBackground = loadedImage != nil
            isLoaded = true
        }
    }

    private static func loadValidImageWithFallback(venueId: VenueId) async -> UIImage? {
        if let image = await loadValidImage(venueId: venueId) {
            return image
        }

        guard venueId != VenueIds.DEFAULT_VALUE else {
            return nil
        }

        return await loadValidImage(venueId: VenueIds.DEFAULT_VALUE)
    }

    private static func loadValidImage(venueId: VenueId) async -> UIImage? {
        guard let url = URL(string: "https://media.api-sports.io/football/venues/\(venueId).png") else {
            return nil
        }

        do {
            let request = URLRequest(
                url: url,
                cachePolicy: .returnCacheDataElseLoad,
                timeoutInterval: 10
            )

            let (data, response) = try await URLSession.shared.data(for: request)

            guard
                !Task.isCancelled,
                let httpResponse = response as? HTTPURLResponse,
                (200..<300).contains(httpResponse.statusCode),
                let image = UIImage(data: data),
                !isPlaceholder(image)
            else {
                return nil
            }

            return image
        } catch {
            return nil
        }
    }

    private static func isPlaceholder(_ image: UIImage) -> Bool {
        image.size.width <= 200 || image.size.height <= 200
    }
}
