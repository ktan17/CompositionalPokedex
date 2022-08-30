//
//  ImageService.swift
//  Pokedex
//
//  Created by Kevin Tan on 8/28/22.
//

import UIKit

actor ImageService {

  // MARK: - Error

  enum Error: Swift.Error {
    case failedToFetch
  }

  // MARK: - Private properties

  private let imageCache = NSCache<NSString, UIImage>()

  // MARK: - Singleton

  static let shared = ImageService()
  private init() { }

  // MARK: - API

  func fetchImage(at url: URL) async throws -> UIImage {
    if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
      return cachedImage
    }

    let (data, _) = try await URLSession.shared.data(from: url)
    guard let image = UIImage(data: data) else {
      throw Error.failedToFetch
    }

    imageCache.setObject(image, forKey: url.absoluteString as NSString)
    return image
  }

}

// MARK: - UIImageView+loadImage

extension UIImageView {
  func loadImage(from url: URL) -> Task<Void, Error> {
    Task { [weak self] in
      do {
        let image = try await ImageService.shared.fetchImage(at: url)
        guard !Task.isCancelled else { return }
        await MainActor.run { [weak self] in
          self?.image = image
        }
      } catch {
        print(error)
      }
    }
  }
}
