//
//  ContentView.swift
//  OpenTopoMaps
//
//  Created by Dmitry Chubarov on 25.02.25.
//

import CoreLocation
import SwiftUI

// NOTES
//
// Estimated download volume per "base" zoom level, down to maximum
// zoom level (15). Approximate tile image size is 40K, 256x256px, PNG format.
// Each tile "contains" exactly four sub-tiles at subsequent zoom level.
//
// Zoom   Span    Images    Download
// ------------------------------------
// x9     58km     5,461      213M
// x10    29km     1,365       53M
// x11    15km       341       13M
// x12     7km        85        4M
//
// TODOS
// - Check if tile provider(s) rate limited.
// - Image .colorInvert() can be used in dark mode.

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
      let tile = MapTile.fromLocationCoordinate(
        location: location,
        zoom: zoom)

      Text("\(Int(tile.metersPerPixel * Double(MapTile.tileSize)))m")
        .font(.caption)
        .foregroundStyle(.secondary)

      let url = "\(mirrors[0])/\(tile.path).png"
      AsyncImage(url: URL(string: url)) { phase in
        switch phase {
        case .success(let image):
          let positionOffset = tile.offsetLocationOf(location: location)

          image
            .resizable()
            .renderingMode(.original)
            .overlay {
              Rectangle().stroke(.black)
              Path { path in
                path.move(to: CGPoint(x: positionOffset.x, y: 0))
                path.addLine(to: CGPoint(x: positionOffset.x, y: CGFloat(MapTile.tileSize)))
                path.move(to: CGPoint(x: 0, y: positionOffset.y))
                path.addLine(to: CGPoint(x: CGFloat(MapTile.tileSize), y: positionOffset.y))
              }
              .stroke(.black, lineWidth: 1)
              .opacity(0.7)
            }

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

      ZStack {
        Capsule()
          .fill(.tertiary)
          .frame(width: 108, height: 34)

        HStack {
          Button(action: { zoom -= 1 }) {
            Image(systemName: "minus.circle")
              .imageScale(.large)
              .foregroundStyle(.tint)
          }
          .disabled(zoom <= ZOOM_RANGE.lowerBound)

          Text("×\(self.zoom)")

          Button(action: { zoom += 1 }) {
            Image(systemName: "plus.circle")
              .imageScale(.large)
              .foregroundStyle(.tint)
          }
          .disabled(zoom >= ZOOM_RANGE.upperBound)
        }
        .padding([.top, .bottom], 8)
      }

      Text(tile.path)

      let origin = tile.originLocation
      Text(
        """
        \(abs(origin.latitude))°\(origin.latitude > 0 ? "N" : "S") : \
        \(abs(origin.longitude))°\(origin.longitude > 0 ? "E" : "W")
        """
      )

      Text("\(tile.metersPerPixel) m/px")
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

#Preview("Wellington, New Zeland") {
  SingleTileView(
    location: CLLocationCoordinate2D(
      latitude: -41.283_589,
      longitude: 174.826_131))
}
