//
//  MeetngTimerView.swift
//  scrumdinger
//
//  Created by Dmitry Chubarov on 18.02.25.
//

import SwiftUI

struct MeetingTimerView: View {
  let speakers: [ScrumTimer.Speaker]
  let isRecording: Bool
  let theme: Theme
  
  private var currentSpeaker: String {
    speakers.first(where: { !$0.isCompleted})?.name ?? "Someone"
  }
  
  var body: some View {
    Circle()
      .strokeBorder(lineWidth: 24)
      .overlay {
        VStack {
          Text(currentSpeaker)
            .font(.title)
          Text("is speaking")
          Image(systemName: isRecording ? "mic" : "mic.slash")
            .accessibilityLabel(isRecording ? "with transcription" : "without transcription")
            .padding(.top)
            .font(.title)
        }
        .accessibilityElement(children: .combine)
        .foregroundStyle(theme.accentColor)
      }
      .overlay {
        ForEach(speakers) { speaker in
          if speaker.isCompleted, let index = speakers.firstIndex(where: { $0.id == speaker.id }) {
            SpeakerArc(speakerIndex: index, totalSpeakers: speakers.count)
              .rotation(Angle(degrees: -90))
              .stroke(theme.mainColor, lineWidth: 12)
          }
        }
      }
      .padding(.horizontal)
  }
}

private struct SpeakerArc : Shape {
  let speakerIndex: Int
  let totalSpeakers: Int
  
  private var degreesPerSpeaker: Double {
    360 / Double(totalSpeakers)
  }
  
  private var startAngle: Angle {
    Angle(degrees: degreesPerSpeaker * Double(speakerIndex) + 1.0)
  }
  
  private var endAngle: Angle {
    Angle(degrees: startAngle.degrees + degreesPerSpeaker - 1.0)
  }
  
  func path(in rect: CGRect) -> Path {
    let radius = (min(rect.size.width, rect.size.height) - 24.0) / 2.0
    let center = CGPoint(x: rect.midX, y: rect.midY)
    return Path { path in
      path.addArc(
        center: center,
        radius: radius,
        startAngle: startAngle,
        endAngle: endAngle,
        clockwise: false)
    }
  }
}

#Preview {
  var speakers: [ScrumTimer.Speaker] {
    [ScrumTimer.Speaker(name: "John", isCompleted: true),
     ScrumTimer.Speaker(name: "Martha", isCompleted: false)]
  }
  MeetingTimerView(
    speakers: speakers,
    isRecording: true,
    theme: .bubblegum)
}
