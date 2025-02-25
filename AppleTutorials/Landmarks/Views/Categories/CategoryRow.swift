//
//  CategoryRow.swift
//  Landmarks
//
//  Created by dime on 24/02/2025.
//

import SwiftUI

struct CategoryRow: View {
  var categoryName: String
  var items: [Landmark]

  var body: some View {
    VStack(alignment: .leading) {
      Text(categoryName)
        .font(.headline)
      ScrollView(.horizontal, showsIndicators: false) {
        HStack {
          ForEach(items) { landmark in
            NavigationLink {
              LandmarkDetail(landmark: landmark)
            } label: {
              CategoryItem(landmark: landmark)
            }
          }
        }
      }
      .frame(height: 185)
    }
  }
}

#Preview {
  let landmarks = ModelData().landmarks
  CategoryRow(
    categoryName: landmarks[0].category.rawValue,
    items: Array(landmarks.prefix(4))
  )
}
