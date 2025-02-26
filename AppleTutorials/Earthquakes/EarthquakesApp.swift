//
//  EarthquakesApp.swift
//  Earthquakes
//
//  Created by Dmitry Chubarov on 26.02.25.
//

import SwiftUI

@main
struct EarthquakesApp: App {
  @StateObject var quakesProvider = QuakesProvider()
  var body: some Scene {
    WindowGroup {
      Quakes()
        .environmentObject(quakesProvider)
    }
  }
}
