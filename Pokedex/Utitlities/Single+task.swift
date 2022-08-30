//
//  Single+task.swift
//  Pokedex
//
//  Created by Kevin Tan on 8/29/22.
//

import RxSwift

extension Single {
  static func task(_ asyncTask: @escaping () async throws -> Element) -> Single<Element> {
    .create { observer in
      let task = Task {
        do {
          observer(.success(try await asyncTask()))
        } catch {
          observer(.failure(error))
        }
      }
      return Disposables.create {
        task.cancel()
      }
    }
  }
}
