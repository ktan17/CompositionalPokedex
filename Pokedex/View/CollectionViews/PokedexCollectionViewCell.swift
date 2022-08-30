//
//  PokedexCollectionViewCell.swift
//  Pokedex
//
//  Created by Kevin Tan on 8/28/22.
//

import UIKit

class PokedexCollectionViewCell: UICollectionViewCell {
  private let nameLabel = UILabel()
  private let stackView = UIStackView()
  private let pokemonImageView = UIImageView()

  private var imageTask: Task<Void, Error>?

  override init(frame: CGRect) {
    super.init(frame: frame)

    backgroundColor = .lightGray
    layer.cornerRadius = theme.smallSpacing
    clipsToBounds = true

    // Configure subviews
    let containerView = with(UIView()) {
      $0.translatesAutoresizingMaskIntoConstraints = false
    }

    with(nameLabel) {
      $0.translatesAutoresizingMaskIntoConstraints = false
      $0.font = theme.titleFont
      $0.textColor = .white
    }

    with(stackView) {
      $0.translatesAutoresizingMaskIntoConstraints = false
      $0.spacing = theme.mediumSpacing
      $0.axis = .vertical
      $0.alignment = .leading
    }

    pokemonImageView.translatesAutoresizingMaskIntoConstraints = false

    stackView.addArrangedSubview(nameLabel)
    containerView.addSubview(stackView)
    containerView.addSubview(pokemonImageView)
    contentView.addSubview(containerView)

    NSLayoutConstraint.activate([
      containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
      containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

      stackView.leadingAnchor.constraint(
        equalTo: containerView.leadingAnchor,
        constant: theme.mediumSpacing
      ),
      stackView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),

      pokemonImageView.trailingAnchor.constraint(
        equalTo: contentView.trailingAnchor,
        constant: 0
      ),
      pokemonImageView.bottomAnchor.constraint(
        equalTo: containerView.bottomAnchor,
        constant: 0
      ),
      pokemonImageView.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.5),
      pokemonImageView.widthAnchor.constraint(equalTo: pokemonImageView.heightAnchor)
    ])
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func configure(with item: Pokemon) {
    backgroundColor = item.types.first?.color
    nameLabel.text = item.name
    if let url = item.imageURL {
      imageTask = pokemonImageView.loadImage(from: url)
    }
    let typePillStack = with(UIStackView(arrangedSubviews: item.types.map { type in
      with(TypePillView()) {
        $0.set(text: type.rawValue)
      }
    })) {
      $0.spacing = theme.smallSpacing
      $0.axis = .vertical
      $0.alignment = .leading
    }
    stackView.addArrangedSubview(typePillStack)
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    imageTask?.cancel()
    pokemonImageView.image = nil
    for subview in stackView.arrangedSubviews {
      guard subview !== nameLabel else { continue }
      stackView.removeArrangedSubview(subview)
      subview.removeFromSuperview()
    }
  }
}
