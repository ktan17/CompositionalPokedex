//
//  LoadingState.swift
//  Pokedex
//
//  Created by Kevin Tan on 8/28/22.
//

enum LoadingState<T> {
  case loading
  case loaded(T)
}
