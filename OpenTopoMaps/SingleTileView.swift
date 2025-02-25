//
//  ContentView.swift
//  OpenTopoMaps
//
//  Created by Dmitry Chubarov on 25.02.25.
//

import CoreLocation
import SwiftUI

let ZOOM_RANGE = 0...16  // upper bound is actually 15

let mirrors: [String] = [
  "https://a.tile.opentopomap.org",
  "https://b.tile.opentopomap.org",
  "https://c.tile.opentopomap.org",
]

struct SingleTileView: View {
  var location: CLLocationCoordinate2D

  @State private var zoom: Int = 10

  var body: some View {
    VStack {
      let tile = tileFromArbitraryCoordinates(
        location: self.location,
        zoom: self.zoom)

      let url = "\(mirrors[0])/\(tile.path).png"
      AsyncImage(url: URL(string: url)) { phase in
        switch phase {
        case .success(let image):
          image
            .resizable()
            .renderingMode(.original)

        case .failure(let error):
          Image(systemName: "exclamationmark.triangle")
            .foregroundStyle(.white)
            .font(.largeTitle)

          Text("\(error)")
            .font(.headline)
            .foregroundStyle(.white)
            .padding(.top, 8)

        default:
          Image(systemName: "map")
            .foregroundStyle(.white)
            .font(.largeTitle)
        }
      }
      .frame(width: 256, height: 256)
      .background(Color.gray)

      HStack {
        Button(action: { zoom -= 1 }) {
          Image(systemName: "minus.circle")
            .imageScale(.large)
            .foregroundStyle(.tint)
        }
        .disabled(zoom == ZOOM_RANGE.lowerBound)

        Text("×\(self.zoom)")

        Button(action: { zoom += 1 }) {
          Image(systemName: "plus.circle")
            .imageScale(.large)
            .foregroundStyle(.tint)
        }
        .disabled(zoom == ZOOM_RANGE.upperBound)
      }
      .padding([.top, .bottom], 8)

      Text(tile.path)

      let origin = tile.originCoordinates
      Text(
        "\(abs(origin.latitude))°\(origin.latitude > 0 ? "N" : "S") : \(abs(origin.longitude))°\(origin.longitude > 0 ? "E" : "W")"
      )

      let metersPerPixel = groundResolution(latitude: origin.latitude, zoom: self.zoom)
      Text("\(metersPerPixel) m/px")
    }
    .padding()
  }
}

#Preview("Tbilisi, Georgia") {
  SingleTileView(
    location: CLLocationCoordinate2D(
      latitude: 41.733_920,
      longitude: 44.739_086))
}

#Preview("Toronto, Canada") {
  SingleTileView(
    location: CLLocationCoordinate2D(
      latitude: 43.613_243,
      longitude: -79.343_428))
}

#Preview("Signey, Australia") {
  SingleTileView(
    location: CLLocationCoordinate2D(
      latitude: -33.865_143,
      longitude: 151.209_900))
}
