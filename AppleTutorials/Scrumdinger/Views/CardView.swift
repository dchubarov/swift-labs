//
//  CardView.swift
//  scrumdinger
//
//  Created by Dmitry Chubarov on 17.02.25.
//

import SwiftUI

struct CardView: View {
  let scrum: DailyScrum

  init(_ scrum: DailyScrum) {
    self.scrum = scrum
  }

  var body: some View {
    VStack(alignment: .leading) {
      Text(scrum.title)
        .font(.headline)
        .accessibilityAddTraits(.isHeader)

      Spacer()

      HStack {
        Label("\(scrum.attendees.count)", systemImage: "person.3")
          .accessibilityLabel("\(scrum.attendees.count) attendees")
        Spacer()
        Label("\(scrum.lengthInMinutes)m", systemImage: "clock")
          .accessibilityLabel("\(scrum.lengthInMinutes) minutes meeting")
          .labelStyle(.trailingIcon)
      }
      .font(.caption)
    }
    .padding()
    .foregroundColor(scrum.theme.accentColor)
  }
}

#Preview(traits: .fixedLayout(width: 400, height: 60)) {
  let scrum = DailyScrum.sampleData[0]
  CardView(scrum)
    .background(scrum.theme.mainColor)
}
