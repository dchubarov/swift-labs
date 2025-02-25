//
//  QuakeDetail.swift
//  Earthquakes
//
//  Created by Dmitry Chubarov on 26.02.25.
//

import SwiftUI

struct QuakeDetail: View {
  var quake: Quake
  @EnvironmentObject private var quakesProvider: QuakesProvider
  @State private var location: QuakeLocation?

  var body: some View {
    VStack {
      if let location = self.location {
        QuakeDetailMap(location: location, tintColor: quake.color)
          .ignoresSafeArea(.container)
      }

      QuakeMagnitude(quake: quake)

      Text(quake.place)
        .font(.title3)
        .bold()

      Text("\(quake.time.formatted())")
        .foregroundStyle(Color.secondary)
      
      if let location = self.location {
        Text("Latitude: \(location.latitude.formatted(.number.precision(.fractionLength(3))))")
        Text("Longitude: \(location.longitude.formatted(.number.precision(.fractionLength(3))))")
      }
    }
    .task {
      if self.location == nil {
        if let quakeLocation = quake.location {
          self.location = quakeLocation
        } else {
          self.location = try? await quakesProvider.location(for: quake)
        }
      }
    }
  }
}

#Preview {
  QuakeDetail(quake: Quake.preview)
}
