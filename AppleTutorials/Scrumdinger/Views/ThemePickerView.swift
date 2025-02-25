//
//  ThemePickerView.swift
//  scrumdinger
//
//  Created by Dmitry Chubarov on 17.02.25.
//

import SwiftUI

struct ThemePickerView: View {
  @Binding var selection: Theme

  var body: some View {
    Picker("Theme", selection: $selection) {
      ForEach(Theme.allCases) { theme in
        ThemeView(theme: theme)
          .tag(theme)
      }
    }
    .pickerStyle(.navigationLink)
  }
}

#Preview {
  ThemePickerView(selection: .constant(.periwinkle))
}
