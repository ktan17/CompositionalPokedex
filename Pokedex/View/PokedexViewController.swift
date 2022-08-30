//
//  PokedexViewController.swift
//  Pokedex
//
//  Created by Kevin Tan on 8/28/22.
//

import RxRelay
import RxSwift
import UIKit

class PokedexViewController: UIViewController {

  // MARK: - MenuOption

  enum MenuOption {
    case `default`
    case groupedByType
  }

  // MARK: - Private properties

  private var collectionView: UICollectionView?
  private let viewModel = PokedexViewModel()
  private let disposeBag = DisposeBag()

  // MARK: - Initializers

  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

    // Configure view
    let menuRelay = PublishRelay<MenuOption>()
    setupNavigationBar(bindingMenuActionsTo: menuRelay)
    view.backgroundColor = .white

    // Bind to view model
    let outputs = viewModel(
      inputs: .init(didTapMenuObservable: menuRelay.asObservable())
    )
    outputs.configurationDriver.drive(onNext: { [weak self] loadingState in
      guard let self = self else { return }

      switch loadingState {
      case .loading:
        break
      case let .loaded(configuration):
        self.collectionView?.removeFromSuperview()

        self.collectionView = with(
          CollectionViewFactory.makeCollectionView(for: configuration)
        ) {
          $0.translatesAutoresizingMaskIntoConstraints = false
          self.view.addSubview($0)
          NSLayoutConstraint.activate([
            $0.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            $0.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            $0.topAnchor.constraint(equalTo: self.view.topAnchor),
            $0.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
          ])
        }
      }
    })
    .disposed(by: disposeBag)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError()
  }

  // MARK: - Private methods

  private func setupNavigationBar(bindingMenuActionsTo menuRelay: PublishRelay<MenuOption>) {
    navigationItem.title = "Pokedex"

    let menu = UIMenu(
      title: "Change Display",
      image: nil,
      identifier: nil,
      options: [],
      children: [
        UIAction(
          title: "Default",
          handler: { _ in menuRelay.accept(.default) }
        ),
        UIAction(
          title: "Grouped by Type",
          handler: { _ in menuRelay.accept(.groupedByType) }
        )
      ]
    )
    navigationItem.rightBarButtonItem = UIBarButtonItem(
      title: nil,
      image: UIImage(systemName: "slider.horizontal.3"),
      primaryAction: nil,
      menu: menu
    )
  }

}

