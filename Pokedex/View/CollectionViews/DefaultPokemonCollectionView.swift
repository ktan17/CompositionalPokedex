//
//  DefaultPokemonCollectionView.swift
//  Pokedex
//
//  Created by Kevin Tan on 8/29/22.
//

import UIKit

class DefaultPokemonCollectionView: UICollectionView {

  enum Section: Int {
    case spotlight
    case twoColumn
  }
  typealias DataSource = UICollectionViewDiffableDataSource<Section, Pokemon>

  // MARK: - Private properties

  private var pokemonDataSource: DataSource?

  // MARK: - Initializers

  private override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
    super.init(frame: frame, collectionViewLayout: layout)
  }

  convenience init(pokemon: [Pokemon]) {
    self.init(frame: .zero, collectionViewLayout: Self.createLayout())
    pokemonDataSource = with(Self.createDataSource(collectionView: self)) {
      Self.seed(dataSource: $0, using: pokemon)
    }
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Static methods

  private static func createLayout() -> UICollectionViewLayout {
    let theme = DefaultTheme()

    // Spotlight
    let spotlightFraction = 0.7
    let spotlightItem = NSCollectionLayoutItem(
      layoutSize: NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(1.0),
        heightDimension: .fractionalWidth(1.0)
      )
    )
    let spotlightGroup = NSCollectionLayoutGroup.horizontal(
      layoutSize: NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(spotlightFraction),
        heightDimension: .fractionalWidth(spotlightFraction)
      ),
      subitems: [spotlightItem]
    )
    let spotlightSection = NSCollectionLayoutSection(group: spotlightGroup)

    // Two column
    let twoColumnItem = NSCollectionLayoutItem(
      layoutSize: NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(1.0),
        heightDimension: .fractionalHeight(1.0)
      )
    )
    let twoColumnGroup = with(NSCollectionLayoutGroup.horizontal(
      layoutSize: NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(1.0),
        heightDimension: .absolute(160.0)
      ),
      subitem: twoColumnItem,
      count: 2
    )) {
      $0.interItemSpacing = .fixed(theme.mediumSpacing)
    }
    let twoColumnSection = with(NSCollectionLayoutSection(group: twoColumnGroup)) {
      $0.interGroupSpacing = theme.mediumSpacing
      $0.contentInsets = NSDirectionalEdgeInsets(
        top: 0,
        leading: theme.mediumSpacing,
        bottom: 0,
        trailing: theme.mediumSpacing
      )
    }

    return UICollectionViewCompositionalLayout { section, environment in
      switch Section(rawValue: section) {
      case .spotlight:
        let inset = ((1 - spotlightFraction) * environment.container.contentSize.width) / 2
        spotlightSection.contentInsets = NSDirectionalEdgeInsets(
          top: theme.mediumSpacing,
          leading: inset,
          bottom: theme.largeSpacing,
          trailing: -inset
        )
        return spotlightSection
      case .twoColumn:
        return twoColumnSection
      case .none:
        fatalError()
      }
    }
  }

  private static func createDataSource(collectionView: UICollectionView) -> DataSource {
    let cellRegistration = UICollectionView.CellRegistration<PokedexCollectionViewCell, Pokemon> { cell, _, item in
      cell.configure(with: item)
    }

    return DataSource(collectionView: collectionView) {
      (collectionView, indexPath, item) -> UICollectionViewCell? in
      collectionView.dequeueConfiguredReusableCell(
        using: cellRegistration,
        for: indexPath,
        item: item
      )
    }
  }

  private static func seed(dataSource: DataSource, using pokemon: [Pokemon]) {
    var snapshot = NSDiffableDataSourceSnapshot<Section, Pokemon>()
    snapshot.appendSections([.spotlight, .twoColumn])

    if let spotlightPokemon = pokemon.randomElement() {
      snapshot.appendItems(
        [with(spotlightPokemon) { $0.id = "spotlight" }],
        toSection: .spotlight
      )
    }
    snapshot.appendItems(pokemon, toSection: .twoColumn)
    dataSource.apply(snapshot, animatingDifferences: false)
  }

}
