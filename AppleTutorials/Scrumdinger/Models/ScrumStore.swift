//
//  ScrumStore.swift
//  scrumdinger
//
//  Created by Dmitry Chubarov on 18.02.25.
//

import SwiftUI

@MainActor
class ScrumStore: ObservableObject {
  @Published var scrums: [DailyScrum] = []

  private static func fileURL() throws -> URL {
    try FileManager.default.url(
      for: .documentDirectory,
      in: .userDomainMask,
      appropriateFor: nil,
      create: false
    )
    .appendingPathComponent("scrums.data")
  }

  func load() async throws {
    let loadTask = Task<[DailyScrum], Error> {
      let fileURL = try Self.fileURL()
      guard let data = try? Data(contentsOf: fileURL) else {
        return []
      }
      let dailyScrums = try JSONDecoder().decode([DailyScrum].self, from: data)
      return dailyScrums
    }

    let scrums = try await loadTask.value
    self.scrums = scrums
  }

  func save(scrums: [DailyScrum]) async throws {
    let saveTask = Task {
      let data = try JSONEncoder().encode(scrums)
      let outFile = try Self.fileURL()
      try data.write(to: outFile)
    }

    _ = try await saveTask.value
  }
}
