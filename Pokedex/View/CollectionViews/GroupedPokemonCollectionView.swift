//
//  GroupedPokemonCollectionView.swift
//  Pokedex
//
//  Created by Kevin Tan on 8/29/22.
//

import UIKit

class GroupedPokemonCollectionView: UICollectionView {

  static let headerKind = "grouped-header-kind"
  typealias DataSource = UICollectionViewDiffableDataSource<PokemonType, Pokemon>

  // MARK: - Private properties

  private var pokemonDataSource: DataSource?

  // MARK: - Initializers

  private override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
    super.init(frame: frame, collectionViewLayout: layout)
  }

  convenience init(groupedPokemon: [(type: String, pokemon: [Pokemon])]) {
    self.init(frame: .zero, collectionViewLayout: Self.createLayout())
    pokemonDataSource = with(Self.createDataSource(collectionView: self)) {
      Self.seed(dataSource: $0, using: groupedPokemon)
    }
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Static methods

  private static func createLayout() -> UICollectionViewLayout {
    let theme = DefaultTheme()
    let interItemSpacing = theme.mediumSpacing
    let widthFraction: Double = 2/3

    return UICollectionViewCompositionalLayout { _, environment in
      let item = NSCollectionLayoutItem(
        layoutSize: NSCollectionLayoutSize(
          widthDimension: .fractionalWidth(1.0),
          heightDimension: .fractionalHeight(1.0)
        )
      )
      let group = NSCollectionLayoutGroup.horizontal(
        layoutSize: NSCollectionLayoutSize(
          widthDimension: .fractionalWidth(widthFraction),
          heightDimension: .absolute(160.0)
        ),
        subitems: [item]
      )
      group.contentInsets = NSDirectionalEdgeInsets(
        top: 0,
        leading: 0,
        bottom: 0,
        trailing: interItemSpacing
      )

      let section = with(NSCollectionLayoutSection(group: group)) {
        $0.contentInsets = NSDirectionalEdgeInsets(
          top: theme.smallSpacing,
          leading: -(environment.container.contentSize.width * (1.0 - widthFraction)) / 2 + interItemSpacing * 2,
          bottom: theme.smallSpacing,
          trailing: 0
        )
        $0.orthogonalScrollingBehavior = .groupPagingCentered

        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
          layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(48)
          ),
          elementKind: Self.headerKind,
          alignment: .top
        )
        sectionHeader.contentInsets.leading = interItemSpacing * 2.5
        $0.boundarySupplementaryItems = [sectionHeader]
      }
      return section
    }
  }

  private static func createDataSource(collectionView: UICollectionView) -> DataSource {
    let cellRegistration = UICollectionView.CellRegistration<PokedexCollectionViewCell, Pokemon> { cell, _, item in
      cell.configure(with: item)
    }

    let pokemonTypes = PokemonType.allSortedCases
    let supplementaryRegistration = UICollectionView.SupplementaryRegistration
    <PokemonTypeHeaderView>(
      elementKind: Self.headerKind
    ) { (supplementaryView, _, indexPath) in
      supplementaryView.set(text: pokemonTypes[indexPath.section].rawValue)
    }

    return with(DataSource(collectionView: collectionView) {
      (collectionView, indexPath, item) -> UICollectionViewCell? in
      collectionView.dequeueConfiguredReusableCell(
        using: cellRegistration,
        for: indexPath,
        item: item
      )
    }) {
      $0.supplementaryViewProvider = { _, _, index in
        collectionView.dequeueConfiguredReusableSupplementary(
          using: supplementaryRegistration,
          for: index
        )
      }
    }
  }

  private static func seed(
    dataSource: DataSource,
    using groupedPokemon: [(type: String, pokemon: [Pokemon])]
  ) {
    let snapshot = groupedPokemon.reduce(
      into: NSDiffableDataSourceSnapshot<PokemonType, Pokemon>()
    ) { snapshot, tuple in
      let (type, pokemon) = tuple
      guard let section = PokemonType(rawValue: type) else { return }
      snapshot.appendSections([section])
      snapshot.appendItems(pokemon, toSection: section)
    }
    dataSource.apply(snapshot, animatingDifferences: false)
  }
}
