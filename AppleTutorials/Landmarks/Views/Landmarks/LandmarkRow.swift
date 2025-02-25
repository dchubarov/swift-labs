//
//  LandmarkRow.swift
//  Landmarks
//
//  Created by dime on 23/02/2025.
//

import SwiftUI

struct LandmarkRow: View {
  var landmark: Landmark
  
  var body: some View {
    HStack {
      landmark.image
        .resizable()
        .frame(width: 40, height: 40)
      Text(landmark.name)
      Spacer()
      
      if landmark.isFavorite {
        Image(systemName: "star.fill")
          .foregroundStyle(.yellow)
      }
    }
  }
}

#Preview {
  let landmarks = ModelData().landmarks
  Group {
    LandmarkRow(landmark: landmarks[0])
    LandmarkRow(landmark: landmarks[1])
  }
}
