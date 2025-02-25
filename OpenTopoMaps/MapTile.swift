//
//  MapTile.swift
//  swift-labs
//
//  Created by Dmitry Chubarov on 25.02.25.
//

import Foundation
import CoreLocation

struct MapTile {
  let x: Int
  let y: Int
  let zoom: Int
  
  /// Origin coordinates of this tile (north-western corner)
  var originCoordinates: CLLocationCoordinate2D {
    let n = pow(2.0, Double(zoom))
    let lon = Double(self.x) / n * 360.0 - 180.0
    let lat = atan(sinh(.pi * (1.0 - 2.0 * Double(self.y) / n))) * 180.0 / .pi
    return CLLocationCoordinate2D(latitude: lat, longitude: lon)
  }

  var path: String {
    "\(zoom)/\(x)/\(y).png"
  }

  static let tileSize = 256
}

/// Given arbitrary geographic location returns map tile coordinates using Slippy Map Tile Names algorithm.
/// - Parameters:
///   - latitude: Latitude.
///   - longitude: Longitude.
///   - zoom: Zoom level.
/// - Returns: MapTile
func tileFromArbitraryCoordinates(latitude: Double, longitude: Double, zoom: Int) -> MapTile {
  let n = pow(2.0, Double(zoom))
  let latRad = latitude * .pi / 180.0
  let xTile = n * (longitude + 180.0) / 360.0
  let yTile = n * (1 - (log(tan(latRad) + 1 / cos(latRad)) / .pi)) / 2
  return MapTile(x: Int(floor(xTile)), y: Int(floor(yTile)), zoom: zoom)
}

func tileFromArbitraryCoordinates(location: CLLocationCoordinate2D, zoom: Int) -> MapTile {
  tileFromArbitraryCoordinates(latitude: location.latitude, longitude: location.longitude, zoom: zoom)
}

/// Calculates ground resolution (meters per pixel) at given latitude and zoom level.
/// - Parameters:
///   - latitude: Latitude.
///   - zoom: Zoom level.
/// - Returns: Meters per pixel.
func groundResolution(latitude: Double, zoom: Int) -> Double {
  let n = pow(2.0, Double(zoom))
  let latRad = latitude * .pi / 180.0
  return (2.0 * .pi * 6_378_137.0) / (Double(MapTile.tileSize) * n) * cos(latRad)
}
