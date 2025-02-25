//
//  ContentView.swift
//  OpenTopoMaps
//
//  Created by Dmitry Chubarov on 25.02.25.
//

import SwiftUI
import CoreLocation

struct MapView: View {
  var location: CLLocationCoordinate2D
  @State var zoom: Int = 10

  var body: some View {
    VStack {
      HStack {
        Button(action: { zoom -= 1 }) {
          Image(systemName: "minus")
            .imageScale(.large)
            .foregroundStyle(.tint)
        }
        Text("×\(self.zoom)")
        Button(action: { zoom += 1 }) {
          Image(systemName: "plus")
            .imageScale(.large)
            .foregroundStyle(.tint)
        }
      }

      let tile = tileFromArbitraryCoordinates(
        location: self.location,
        zoom: self.zoom)
      Text("\(tile.x)X : \(tile.y, specifier: "%d")Y")

      let origin = tile.originCoordinates
      Text("\(abs(origin.latitude))°\(origin.latitude > 0 ? "N" : "S") : \(abs(origin.longitude))°\(origin.longitude > 0 ? "E" : "W")")

      let metersPerPixel = groundResolution(latitude: origin.latitude, zoom: self.zoom)
      Text("\(metersPerPixel) m/px")

      Text(tile.path)
    }
    .padding()
  }
}

#Preview("Tbilisi, Georgia") {
  MapView(
    location: CLLocationCoordinate2D(
      latitude: 41.733_920,
      longitude: 44.739_086))
}

#Preview("Signey, Australia") {
  MapView(
    location: CLLocationCoordinate2D(
      latitude: -33.865_143,
      longitude: 151.209_900))
}
