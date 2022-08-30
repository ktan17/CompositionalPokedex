//
//  PokemonService.swift
//  Pokedex
//
//  Created by Kevin Tan on 8/28/22.
//

import Foundation

actor PokemonService {
  private struct PokemonJSON: Codable {
    struct Names: Codable {
      let english: String
    }
    let id: Int
    let name: Names
    let type: [String]
  }

  enum Error: Swift.Error {
    case failedToFetch
  }

  // MARK: - Singleton

  static let shared = PokemonService()
  private init() { }

  // MARK: - API

  func fetchPokemon() async throws -> [Pokemon] {
    guard let path = Bundle.main.path(forResource: "pokedex", ofType: "json") else {
      throw Error.failedToFetch
    }
    let url = URL(fileURLWithPath: path)
    let (data, _) = try await URLSession.shared.data(from: url)
    let json = try JSONDecoder().decode([PokemonJSON].self, from: data)
    return json.map {
      Pokemon(
        id: String($0.id),
        name: $0.name.english,
        types: $0.type.compactMap(PokemonType.init),
        imageURL: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\($0.id).png")
      )
    }
    .prefix(151)
    .asArray()
  }
}

fileprivate extension ArraySlice {
  func asArray() -> Array<Element> {
    Array(self)
  }
}
