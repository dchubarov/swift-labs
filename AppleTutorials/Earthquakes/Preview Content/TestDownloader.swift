//
//  TestDownloader.swift
//  swift-labs
//
//  Created by Dmitry Chubarov on 26.02.25.
//

import Foundation

class TestDownloader: HTTPDataDownloader {
  func httpData(from url: URL) async throws -> Data {
    try await Task.sleep(nanoseconds: UInt64.random(in: 100_000_000...500_000_000))
    return testQuakesData
  }
}
