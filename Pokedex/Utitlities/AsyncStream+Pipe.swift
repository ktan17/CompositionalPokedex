//
//  AsyncStream+Pipe.swift
//  Pokedex
//
//  Created by Kevin Tan on 8/28/22.
//

import Foundation

extension AsyncStream {
  static func pipe() -> ((Element) -> Void, Self) {
    var input: (Element) -> Void = { _ in }
    let output = Self { continuation in
      input = { element in
        continuation.yield(element)
      }
    }
    return (input, output)
  }
}
