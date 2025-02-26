//
//  CacheEntryObject.swift
//  swift-labs
//
//  Created by Dmitry Chubarov on 26.02.25.
//

import Foundation

final class CacheEntryObject {
  let entry: CacheEntry
  init(entry: CacheEntry) { self.entry = entry }
}

enum CacheEntry {
  case inProgress(Task<QuakeLocation, Error>)
  case ready(QuakeLocation)
}
