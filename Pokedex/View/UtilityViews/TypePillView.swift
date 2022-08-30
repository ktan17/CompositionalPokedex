//
//  TypePillView.swift
//  Pokedex
//
//  Created by Kevin Tan on 8/28/22.
//

import UIKit

class TypePillView: UIView {
  private let label = UILabel()

  override init(frame: CGRect) {
    super.init(frame: frame)

    let height: Double = 40

    translatesAutoresizingMaskIntoConstraints = false
    backgroundColor = .white.withAlphaComponent(0.35)
    layer.cornerRadius = height / 2
    clipsToBounds = true

    with(label) {
      $0.translatesAutoresizingMaskIntoConstraints = false
      $0.font = theme.bodyFont
      $0.textColor = .white
    }
    addSubview(label)

    NSLayoutConstraint.activate([
      label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: theme.mediumSpacing),
      label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -theme.mediumSpacing),
      label.centerXAnchor.constraint(equalTo: centerXAnchor),
      label.centerYAnchor.constraint(equalTo: centerYAnchor),

      heightAnchor.constraint(equalToConstant: height)
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
