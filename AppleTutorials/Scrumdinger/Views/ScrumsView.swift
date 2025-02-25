//
//  ScrumsView.swift
//  scrumdinger
//
//  Created by Dmitry Chubarov on 17.02.25.
//

import SwiftUI

struct ScrumsView: View {
  @Binding var scrums: [DailyScrum]
  @State private var isPresentingNewScrumView = false
  @Environment(\.scenePhase) private var scenePhase
  let saveAction: () -> Void

  var body: some View {
    NavigationStack {
      List($scrums) { $scrum in
        NavigationLink(destination: DetailView(scrum: $scrum)) {
          CardView(scrum)
        }
        .listRowBackground(scrum.theme.mainColor)
      }
      .navigationTitle("Daily Scrums")
      .toolbar {
        Button(action: {
          isPresentingNewScrumView = true
        }) {
          Image(systemName: "plus")
        }
        .accessibilityLabel("New Scrum")
      }
    }
    .sheet(isPresented: $isPresentingNewScrumView) {
      NewScrumSheet(
        scrums: $scrums,
        isPresentingNewScrumView: $isPresentingNewScrumView)
    }
    .onChange(of: scenePhase) { phase in
      if phase == .inactive {
        saveAction()
      }
    }
  }
}

#Preview {
  ScrumsView(scrums: .constant(DailyScrum.sampleData), saveAction: {})
}
