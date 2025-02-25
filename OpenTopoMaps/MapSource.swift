//
//  MapSource.swift
//  swift-labs
//
//  Created by Dmitry Chubarov on 25.02.25.
//

struct MapSource: Identifiable, Hashable {
  let id: String
  let layers: [Layer]
  let zoomRange: ClosedRange<Int>

  init(_ id: String, layers: [Layer], zoomRange: ClosedRange<Int>) {
    self.id = id
    self.layers = layers
    self.zoomRange = zoomRange
  }

  struct Layer: Identifiable, Hashable {
    let id: String
    let mirrors: [Mirror]

    init(_ id: String, mirrors: [Mirror]) {
      self.id = id
      self.mirrors = mirrors
    }
  }

  struct Mirror: Hashable {
    let baseUrl: String
  }
}

extension MapSource {
  static var openStreetMap: MapSource {
    .init(
      "OpenStreetMap",
      layers: [
        .init("osm", mirrors: [.init(baseUrl: "https://tile.openstreetmap.org")])
      ],
      zoomRange: 0...19
    )
  }

  static var openTopoMap: MapSource {
    .init(
      "OpenTopoMap",
      layers: [
        .init(
          "otm",
          mirrors: [
            .init(baseUrl: "https://a.tile.opentopomap.org"),
            .init(baseUrl: "https://b.tile.opentopomap.org"),
            .init(baseUrl: "https://c.tile.opentopomap.org"),
          ])
      ],
      zoomRange: 0...15
    )
  }

  static var openSeaMap: MapSource {
    .init(
      "OpenSeaMap",
      layers: [
        openStreetMap.layers[0],
        .init(
          "seamark",
          mirrors: [
            .init(baseUrl: "https://tiles.openseamap.org/seamark")
          ])
      ],
      zoomRange: 0...18
    )
  }
}
