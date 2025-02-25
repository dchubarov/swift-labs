//
//  MeetingFooterView.swift
//  scrumdinger
//
//  Created by Dmitry Chubarov on 18.02.25.
//

import SwiftUI

struct MeetingFooterView: View {
  let speakers: [ScrumTimer.Speaker]
  var skipAction: () -> Void

  private var speakerNumber: Int? {
    guard let index = speakers.firstIndex(where: { !$0.isCompleted }) else {
      return nil
    }
    return index + 1
  }

  private var speakerText: String {
    guard let speakerNumber = speakerNumber else { return "No more speakers" }
    return "Speaker \(speakerNumber) of \(speakers.count)"
  }

  private var isLastSpeaker: Bool {
    speakers.dropLast().allSatisfy { $0.isCompleted }
  }

  var body: some View {
    VStack {
      HStack {
        if isLastSpeaker {
          Text("Last Speaker")
        } else {
          Text("Speaker \(speakerNumber ?? -1) of \(speakers.count)")
          Spacer()
          Button(action: skipAction) {
            Image(systemName: "forward.fill")
          }
          .accessibilityLabel("Next speaker")
        }
      }
    }
    .padding([.bottom, .horizontal])
  }
}

#Preview(traits: .sizeThatFitsLayout) {
  MeetingFooterView(
    speakers: DailyScrum.sampleData[0].attendees.speakers, skipAction: {})
}
