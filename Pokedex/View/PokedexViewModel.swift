//
//  PokedexViewModel.swift
//  Pokedex
//
//  Created by Kevin Tan on 8/28/22.
//

import RxCocoa
import RxSwift

@MainActor
class PokedexViewModel {

  // MARK: - Models

  enum CollectionConfiguration {
    case `default`([Pokemon])
    case groupedByType([(type: String, pokemon: [Pokemon])])
  }

  // MARK: - Inputs & Outputs

  struct Inputs {
    let didTapMenuObservable: Observable<PokedexViewController.MenuOption>
  }

  struct Outputs {
    let configurationDriver: Driver<LoadingState<CollectionConfiguration>>
  }

  // MARK: - Private properties

  private var pokemon = [Pokemon]()

  func callAsFunction(inputs: Inputs) -> Outputs {
    let configurationDriver = Observable.combineLatest(
      Single.task(PokemonService.shared.fetchPokemon).asObservable(),
      inputs.didTapMenuObservable.startWith(.default)
    ) { pokemon, menuOption -> LoadingState<CollectionConfiguration> in
      switch menuOption {
      case .`default`:
        return .loaded(.default(pokemon))
      case .groupedByType:
        return .loaded(.groupedByType(
          PokemonType.allSortedCases
            .map { type in
              (type.rawValue, pokemon.filter { $0.types.contains(type) })
            }
            .filter { !$1.isEmpty }
        ))
      }
    }
    .startWith(.loading)
    .asDriver(onErrorJustReturn: .loading)

    return Outputs(
      configurationDriver: configurationDriver
    )
  }
}
