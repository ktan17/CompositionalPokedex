//
//  PokemonTypeHeaderView.swift
//  Pokedex
//
//  Created by Kevin Tan on 8/29/22.
//

import UIKit

class PokemonTypeHeaderView: UICollectionReusableView {
  private let label = UILabel()

  override init(frame: CGRect) {
    super.init(frame: frame)

    with(label) {
      $0.translatesAutoresizingMaskIntoConstraints = false
      $0.font = theme.headlineFont
      $0.textColor = traitCollection.userInterfaceStyle == .dark ? .white : .black
      addSubview($0)
    }

    NSLayoutConstraint.activate([
      label.leadingAnchor.constraint(
        equalTo: leadingAnchor,
        constant: theme.smallSpacing
      ),
      label.centerYAnchor.constraint(equalTo: centerYAnchor)
    ])
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func set(text: String) {
    label.text = text
  }
}
