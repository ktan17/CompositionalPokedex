//
//  Pokemon.swift
//  Pokedex
//
//  Created by Kevin Tan on 8/28/22.
//

import Foundation
import UIKit

struct Pokemon: Hashable {
  var id: String
  var name: String
  var types: [PokemonType]
  var imageURL: URL?

  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }

  static func == (lhs: Pokemon, rhs: Pokemon) -> Bool {
    lhs.id == rhs.id
  }
}

enum PokemonType: String, CaseIterable {
  case normal = "Normal"
  case fire = "Fire"
  case water = "Water"
  case grass = "Grass"
  case electric = "Electric"
  case ice = "Ice"
  case fighting = "Fighting"
  case poison = "Poison"
  case ground = "Ground"
  case flying = "Flying"
  case psychic = "Psychic"
  case bug = "Bug"
  case rock = "Rock"
  case ghost = "Ghost"
  case dark = "Dark"
  case dragon = "Dragon"
  case steel = "Steel"
  case fairy = "Fairy"

  var color: UIColor {
    switch self {
    case .normal:
      return UIColor(red: 168/255, green: 168/255, blue: 125/255, alpha: 0.8)
    case .fire:
      return UIColor(red: 225/255, green: 134/255, blue: 68/255, alpha: 0.8)
    case .water:
      return UIColor(red: 112/255, green: 143/255, blue: 233/255, alpha: 0.8)
    case .grass:
      return UIColor(red: 139/255, green: 198/255, blue: 96/255, alpha: 0.8)
    case .electric:
      return UIColor(red: 242/255, green: 210/255, blue: 84/255, alpha: 0.8)
    case .ice:
      return UIColor(red: 166/255, green: 214/255, blue: 215/255, alpha: 0.8)
    case .fighting:
      return UIColor(red: 177/255, green: 61/255, blue: 49/255, alpha: 0.8)
    case .poison:
      return UIColor(red: 148/255, green: 70/255, blue: 155/255, alpha: 0.8)
    case .ground:
      return UIColor(red: 219/255, green: 193/255, blue: 117/255, alpha: 0.8)
    case .flying:
      return UIColor(red: 164/255, green: 145/255, blue: 234/255, alpha: 0.8)
    case .psychic:
      return UIColor(red: 230/255, green: 99/255, blue: 136/255, alpha: 0.8)
    case .bug:
      return UIColor(red: 171/255, green: 184/255, blue: 66/255, alpha: 0.8)
    case .rock:
      return UIColor(red: 181/255, green: 161/255, blue: 75/255, alpha: 0.8)
    case .ghost:
      return UIColor(red: 108/255, green: 89/255, blue: 148/255, alpha: 0.8)
    case .dark:
      return UIColor(red: 108/255, green: 89/255, blue: 74/255, alpha: 0.8)
    case .dragon:
      return UIColor(red: 105/255, green: 59/255, blue: 239/255, alpha: 0.8)
    case .steel:
      return UIColor(red: 184/255, green: 184/255, blue: 206/255, alpha: 0.8)
    case .fairy:
      return UIColor(red: 231/255, green: 184/255, blue: 189/255, alpha: 0.8)
    }
  }

  var sortPosition: Int {
    switch self {
    case .normal:
      return 0
    case .fire:
      return 1
    case .water:
      return 2
    case .grass:
      return 3
    case .electric:
      return 4
    case .ice:
      return 5
    case .fighting:
      return 6
    case .poison:
      return 7
    case .ground:
      return 8
    case .flying:
      return 9
    case .psychic:
      return 10
    case .bug:
      return 11
    case .rock:
      return 12
    case .ghost:
      return 13
    case .dark:
      return 14
    case .dragon:
      return 15
    case .steel:
      return 16
    case .fairy:
      return 17
    }
  }

  static let allSortedCases = Self.allCases.sorted {
    $0.sortPosition < $1.sortPosition
  }
}
