//
//  QuakeClient.swift
//  swift-labs
//
//  Created by Dmitry Chubarov on 26.02.25.
//

import Foundation

actor QuakeClient {
  private let quakeCache: NSCache<NSString, CacheEntryObject> = NSCache()

  var quakes: [Quake] {
    get async throws {
      let data = try await downloader.httpData(from: feedURL)
      let allQuakes = try decoder.decode(GeoJSON.self, from: data)
      var updatedQuakes = allQuakes.quakes
      if let olderThanOneHour = updatedQuakes.firstIndex(where: {  $0.time.timeIntervalSinceNow > 3600 }) {
        let indexRange = updatedQuakes.startIndex..<olderThanOneHour
        try await withThrowingTaskGroup(of: (Int, QuakeLocation).self) { group in
          for index in indexRange {
            group.addTask {
              let location = try await self.quakeLocation(from: allQuakes.quakes[index].detail)
              return (index, location)
            }
          }
          while let result = await group.nextResult() {
            switch result {
            case .success(let (index, location)):
              updatedQuakes[index].location = location
            case .failure(let error):
              throw error
            }
          }
        }
      }
      return updatedQuakes
    }
  }

  private lazy var decoder: JSONDecoder = {
    let aDecoder = JSONDecoder()
    aDecoder.dateDecodingStrategy = .millisecondsSince1970
    return aDecoder
  }()

  private let feedURL = URL(string: "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.geojson")!
  private let downloader: any HTTPDataDownloader

  init(downloader: any HTTPDataDownloader = URLSession.shared) {
    self.downloader = downloader
  }

  func quakeLocation(from url: URL) async throws -> QuakeLocation {
    if let cachedLocation = quakeCache[url] {
      switch cachedLocation {
      case .inProgress(let task):
        return try await task.value
      case .ready(let location):
        return location
      }
    }

    let task = Task<QuakeLocation, Error> {
      let data = try await downloader.httpData(from: url)
      let location = try decoder.decode(QuakeLocation.self, from: data)
      return location
    }
    quakeCache[url] = .inProgress(task)
    do {
      let location = try await task.value
      quakeCache[url] = .ready(location)
      return location
    } catch {
      quakeCache[url] = nil
      throw error
    }
  }
}
