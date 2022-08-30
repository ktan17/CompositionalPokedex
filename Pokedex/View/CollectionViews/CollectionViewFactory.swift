//
//  CollectionViewFactory.swift
//  Pokedex
//
//  Created by Kevin Tan on 8/29/22.
//

import Foundation
import UIKit

enum CollectionViewFactory {
  static func makeCollectionView(
    for configuration: PokedexViewModel.CollectionConfiguration
  ) -> UICollectionView {
    switch configuration {
    case let .`default`(pokemon):
      return DefaultPokemonCollectionView(pokemon: pokemon)
    case let .groupedByType(groupedPokemon):
      return GroupedPokemonCollectionView(groupedPokemon: groupedPokemon)
    }
  }
}
