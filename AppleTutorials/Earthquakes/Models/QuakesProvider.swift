//
//  QuakesProvider.swift
//  swift-labs
//
//  Created by Dmitry Chubarov on 26.02.25.
//

import Foundation

class QuakesProvider: ObservableObject {
  @Published var quakes: [Quake] = []
  let client: QuakeClient

  init(client: QuakeClient = QuakeClient()) {
    self.client = client
  }

  func fetchQuakes() async throws {
    let latestQuakes = try await client.quakes
    self.quakes = latestQuakes
  }

  func deleteQuakes(atOffsets offsets: IndexSet) {
    quakes.remove(atOffsets: offsets)
  }
}
