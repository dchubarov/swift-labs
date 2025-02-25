//
//  FavoriteButton.swift
//  Landmarks
//
//  Created by dime on 23/02/2025.
//

import SwiftUI

struct FavoriteButton: View {
  @Binding var isSet: Bool
  
  var body: some View {
    Button {
      isSet.toggle()
    } label: {
      Label("Toggle Favorite", systemImage: isSet ? "star.fill" : "star")
        .labelStyle(.iconOnly)
        .foregroundStyle(isSet ? .yellow : .gray)
    }
  }
}

#Preview {
  Group {
    FavoriteButton(isSet: .constant(true))
    FavoriteButton(isSet: .constant(false))
  }
}
