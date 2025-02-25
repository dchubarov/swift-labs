//
//  MeetingHeaderView.swift
//  scrumdinger
//
//  Created by Dmitry Chubarov on 18.02.25.
//

import SwiftUI

struct MeetingHeaderView: View {
  let secondsElapsed: Int
  let secondsRemaining: Int
  let theme: Theme

  private var totalSeconds: Int {
    secondsElapsed + secondsRemaining
  }

  private var minutesRemaining: Int {
    secondsRemaining / 60
  }

  private var progress: Double {
    guard totalSeconds > 0 else { return 1 }
    return Double(secondsElapsed) / Double(totalSeconds)
  }

  var body: some View {
    VStack {
      ProgressView(value: progress)
        .progressViewStyle(ScrumProgressViewStyle(theme: theme))

      HStack {
        VStack(alignment: .leading) {
          Text("Seconds elapsed")
            .font(.caption)
          Label("\(secondsElapsed)", systemImage: "hourglass.tophalf.fill")
        }

        Spacer()

        VStack(alignment: .trailing) {
          Text("Seconds remaining")
            .font(.caption)
          Label("\(secondsRemaining)", systemImage: "hourglass.bottomhalf.fill")
            .labelStyle(.trailingIcon)
        }
      }
    }
    .accessibilityElement(children: .ignore)
    .accessibilityLabel("Time remaining")
    .accessibilityValue("\(minutesRemaining) minutes")
    .padding([.top, .horizontal])
  }
}

#Preview(traits: .sizeThatFitsLayout) {
  MeetingHeaderView(secondsElapsed: 60, secondsRemaining: 180, theme: .sky)
}
