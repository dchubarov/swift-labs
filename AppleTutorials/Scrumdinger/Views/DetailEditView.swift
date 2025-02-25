//
//  DetailEditView.swift
//  scrumdinger
//
//  Created by Dmitry Chubarov on 17.02.25.
//

import SwiftUI

struct DetailEditView: View {
  @Binding var scrum: DailyScrum
  @State private var newAttendeeName: String = ""

  var body: some View {
    Form {
      Section(header: Text("Meeting Info")) {
        TextField("Title", text: $scrum.title)
        HStack {
          Slider(value: $scrum.lengthInMinutesAsDouble, in: 5...30, step: 1) {
            Text("Length")
          }
          .accessibilityValue("\(scrum.lengthInMinutes) minutes")
          Spacer()
          Text("\(scrum.lengthInMinutes)m")
            .accessibilityHidden(true)
        }

        ThemePickerView(selection: $scrum.theme)
      }

      Section(header: Text("Attendees")) {
        ForEach(scrum.attendees) { attendee in
          Text(attendee.name)
        }
        .onDelete { indicies in
          scrum.attendees.remove(atOffsets: indicies)
        }

        HStack {
          TextField("New Attendee", text: $newAttendeeName)
          Button(action: {
            withAnimation {
              let attendee = DailyScrum.Attendee(name: newAttendeeName)
              scrum.attendees.append(attendee)
              newAttendeeName = ""
            }
          }) {
            Image(systemName: "plus.circle.fill")
              .accessibilityLabel("Add attendee")
          }
          .disabled(newAttendeeName.isEmpty)
        }
      }
    }
  }
}

#Preview {
  DetailEditView(scrum: .constant(DailyScrum.sampleData[0]))
}
