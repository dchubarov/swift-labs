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
// Multiple by number of layers in MapSource.
//
// Zoom   Span    Images    Download
// ------------------------------------
// x9     58km     5,461      213M
// x10    29km     1,365       53M
// x11    15km       341       13M  *
// x12     7km        85        4M
//
// TODOS
// - Check if tile provider(s) rate limited.

struct SingleTileView: View {
  @Environment(\.colorScheme) var colorScheme

  @State private var selectedMapSource: MapSource = .openTopoMap
  @State private var placemark: String?
  @State private var zoom: Int = 11

  var location: CLLocationCoordinate2D

  var body: some View {
    VStack {
      let tile = MapTile.fromLocationCoordinate(
        location: location,
        zoom: zoom)

      Picker("Map Source", selection: $selectedMapSource) {
        Text(MapSource.openStreetMap.id).tag(MapSource.openStreetMap)
        Text(MapSource.openTopoMap.id).tag(MapSource.openTopoMap)
        Text(MapSource.openSeaMap.id).tag(MapSource.openSeaMap)
      }

      Spacer()

      Text("\(Int(tile.metersPerPixel * Double(MapTile.tileSize)))m")
        .font(.caption)
        .foregroundStyle(.secondary)

      let url = "\(selectedMapSource.layers[0].mirrors[0].baseUrl)/\(tile.path)"
      AsyncImage(url: URL(string: url)) { phase in
        switch phase {
        case .success(let image):
          let positionOffset = tile.offsetLocationOf(location: location)
          image
            .resizable()
            .blendMode(colorScheme == .dark ? .difference : .normal)
            .overlay {
              Rectangle().stroke()
              Path { path in
                path.move(to: CGPoint(x: positionOffset.x, y: 0))
                path.addLine(to: CGPoint(x: positionOffset.x, y: CGFloat(MapTile.tileSize)))
                path.move(to: CGPoint(x: 0, y: positionOffset.y))
                path.addLine(to: CGPoint(x: CGFloat(MapTile.tileSize), y: positionOffset.y))
              }
              .stroke(colorScheme == .dark ? .white : .black, lineWidth: 1)
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
          .disabled(zoom <= selectedMapSource.zoomRange.lowerBound)

          Text("×\(self.zoom)")

          Button(action: { zoom += 1 }) {
            Image(systemName: "plus.circle")
              .imageScale(.large)
              .foregroundStyle(.tint)
          }
          .disabled(zoom >= selectedMapSource.zoomRange.upperBound)
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
      Text("\(selectedMapSource.layers.count) layer(s)")

      Spacer()

      Text(placemark ?? "")
        .foregroundStyle(.secondary)
        .padding(.top, 8)
        .lineLimit(nil)

    }
    .padding()
    .onAppear {
      let geocoder = CLGeocoder()
      geocoder.reverseGeocodeLocation(
        CLLocation(
          latitude: location.latitude,
          longitude: location.longitude)
      ) { (placemarks, error) in
        if error != nil {
          placemark = "Error retrieving address"
        }

        if let placemarks = placemarks, let firstPlacemark = placemarks.first {
          placemark = """
            \(firstPlacemark.name ?? "") \
            \(firstPlacemark.locality ?? "") \
            \(firstPlacemark.country ?? "")
            """
        }
      }
    }
  }
}

#Preview("Sioni, Georgia") {
  SingleTileView(
    location: CLLocationCoordinate2D(
      latitude: 41.990_923,
      longitude: 45.017_195))
}

#Preview("Toronto, Canada") {
  SingleTileView(
    location: CLLocationCoordinate2D(
      latitude: 43.632_237,
      longitude: -79.396_036))
}

#Preview("Wellington, New Zeland") {
  SingleTileView(
    location: CLLocationCoordinate2D(
      latitude: -41.283_589,
      longitude: 174.826_131))
}
