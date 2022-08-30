//
//  Theme.swift
//  Pokedex
//
//  Created by Kevin Tan on 8/28/22.
//

import UIKit

// MARK: - Protocols

protocol Themeable {
  var theme: Theme { get }
}

protocol Theme {
  var smallSpacing: Double { get }
  var mediumSpacing: Double { get }
  var largeSpacing: Double { get }
  var headlineFont: UIFont { get }
  var titleFont: UIFont { get }
  var bodyFont: UIFont { get }
}

// MARK: - DefaultTheme

struct DefaultTheme: Theme {
  let smallSpacing: Double = 8
  let mediumSpacing: Double = 16
  let largeSpacing: Double = 24
  let headlineFont = UIFont.boldSystemFont(ofSize: 20)
  let titleFont = UIFont.boldSystemFont(ofSize: 14)
  let bodyFont = UIFont.systemFont(ofSize: 12)
}

// MARK: - UIKit+Theme

extension UIViewController: Themeable {
  var theme: any Theme { DefaultTheme() }
}

extension UIView: Themeable {
  var theme: any Theme { DefaultTheme() }
}
