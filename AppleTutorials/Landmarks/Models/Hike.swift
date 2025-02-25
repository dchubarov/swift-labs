//
//  Hike.swift
//  swift-labs
//
//  Created by dime on 24/02/2025.
//

import Foundation

struct Hike: Codable, Hashable, Identifiable {
  var id: Int
  var name: String
  var distance: Double
  var difficulty: Int
  var observations: [Observation]
  
  static var formatter = LengthFormatter()
  
  var distanceText: String {
    Self.formatter.string(fromValue: distance, unit: .kilometer)
  }
  
  struct Observation: Codable, Hashable {
    var distanceFromStart: Double
    var elevation: Range<Double>
    var pace: Range<Double>
    var heartRate: Range<Double>
  }
  
}
