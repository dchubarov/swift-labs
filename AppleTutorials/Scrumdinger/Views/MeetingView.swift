//
//  ContentView.swift
//  scrumdinger
//
//  Created by Dmitry Chubarov on 17.02.25.
//

import SwiftUI

struct MeetingView: View {
  @Binding var scrum: DailyScrum
  @StateObject var scrumTimer = ScrumTimer()
  @StateObject var speechRecognizer = SpeechRecognizer()
  @State private var isRecording = false

  var body: some View {
    ZStack {
      RoundedRectangle(cornerRadius: 16)
        .fill(scrum.theme.mainColor)

      VStack {
        MeetingHeaderView(
          secondsElapsed: scrumTimer.secondsElapsed,
          secondsRemaining: scrumTimer.secondsRemaining,
          theme: scrum.theme)

        MeetingTimerView(
          speakers: scrumTimer.speakers,
          isRecording: isRecording,
          theme: scrum.theme
        )

        MeetingFooterView(
          speakers: scrumTimer.speakers,
          skipAction: scrumTimer.skipSpeaker
        )
      }
    }
    .padding()
    .foregroundColor(scrum.theme.accentColor)
    .navigationBarTitleDisplayMode(.inline)
    .onAppear {
      startScrum()
    }
    .onDisappear {
      endScrum()
    }
  }

  private func startScrum() {
    scrumTimer.reset(lengthInMinutes: scrum.lengthInMinutes, attendees: scrum.attendees)
    speechRecognizer.resetTranscript()
    speechRecognizer.startTranscribing()
    isRecording = true
    scrumTimer.startScrum()
  }

  private func endScrum() {
    scrumTimer.stopScrum()
    speechRecognizer.stopTranscribing()
    isRecording = false
    let newHistory = History(attendees: scrum.attendees, transcript: speechRecognizer.transcript)
    scrum.history.insert(newHistory, at: 0)
  }
}

#Preview {
  MeetingView(scrum: .constant(DailyScrum.sampleData[0]))
}
