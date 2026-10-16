import SwiftUI

struct FailView: View {
  let notice: Experiment.Notice
  let dismiss: () -> Void

  var body: some View {
    ZStack {
      RoundedRectangle(cornerRadius: 20)
        .foregroundColor(Color(hex: notice == .completedCollection ? 0xF19203 : 0xFF8888))
      VStack {
        LabButtonLabel(
          title: notice == .completedCollection ? "Great!" : "Oops",
          imageName: "button_image",
          font: .system(.largeTitle, design: .rounded))
        Divider()
        Spacer()
        Text(notice.message)
          .padding()
          .font(.system(.title2, design: .rounded))
        Spacer()
        Button(action: dismiss) { LabButtonLabel(title: "OK") }
      }
      .padding()
      .foregroundColor(.white)
    }
    .frame(width: 600, height: 350)
    .shadow(radius: 20)
  }
}
