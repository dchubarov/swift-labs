//
//  MapTile.swift
//  swift-labs
//
//  Created by Dmitry Chubarov on 25.02.25.
//

import Foundation
import CoreLocation

struct MapTile {
  private var xTile: Double
  private var yTile: Double
  private(set) var metersPerPixel: Double
  var zoom: Int

  var x: Int {
    Int(floor(xTile))
  }

  var y: Int {
    Int(floor(yTile))
  }

  var path: String {
    "\(zoom)/\(x)/\(y).png"
  }

  var originLocation: CLLocationCoordinate2D {
    let n = pow(2.0, Double(zoom))
    let lon = Double(x) / n * 360.0 - 180.0
    let lat = atan(sinh(.pi * (1.0 - 2.0 * Double(y) / n))) * 180.0 / .pi
    return CLLocationCoordinate2D(latitude: lat, longitude: lon)
  }

  func offsetLocationOf(location: CLLocationCoordinate2D) -> CGPoint {
    let xPixel = Int(Double(MapTile.tileSize) * (xTile - floor(xTile)))
    let yPixel = Int(Double(MapTile.tileSize) * (yTile - floor(yTile)))
    return CGPoint(x: xPixel, y: yPixel)
  }

  /// Given arbitrary geographic location returns map tile coordinates using Slippy Map Tile Names algorithm.
  /// - Parameters:
  ///   - latitude: Latitude.
  ///   - longitude: Longitude.
  ///   - zoom: Zoom level.
  /// - Returns: MapTile
  static func fromLocationCoordinate(latitude: Double, longitude: Double, zoom: Int) -> MapTile {
    let n = pow(2.0, Double(zoom))
    let latRad = latitude * .pi / 180.0
    let xTile = n * (longitude + 180.0) / 360.0
    let yTile = n * (1 - (log(tan(latRad) + 1 / cos(latRad)) / .pi)) / 2
    let res = (2.0 * .pi * 6_378_137.0) / (Double(MapTile.tileSize) * n) * cos(latRad)
    return MapTile(xTile: xTile, yTile: yTile, metersPerPixel: res, zoom: zoom)
  }

  static func fromLocationCoordinate(location: CLLocationCoordinate2D, zoom: Int) -> MapTile {
    return Self.fromLocationCoordinate(
      latitude: location.latitude,
      longitude: location.longitude,
      zoom: zoom)
  }

  static let tileSize = 256
}
