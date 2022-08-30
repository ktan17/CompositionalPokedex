//
//  With.swift
//  Pokedex
//
//  Created by Kevin Tan on 8/28/22.
//

@discardableResult
public func with<T>(_ item: T, update: (inout T) throws -> Void) rethrows -> T {
  var copy = item
  try update(&copy)
  return copy
}
