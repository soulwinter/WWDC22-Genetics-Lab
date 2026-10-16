import SwiftUI

@MainActor
struct SucceedView: View {
  let harvest: Harvest
  let newIDs: Set<Int>
  let lesson: Lesson
  @Binding var showSucceedView: Bool

  private let columns = [GridItem(.adaptive(minimum: 100, maximum: 300))]

  var body: some View {
    ZStack {
      RoundedRectangle(cornerRadius: 20).foregroundColor(.green)
      VStack {
        LabButtonLabel(
          title: "Harvest", imageName: "button_image",
          font: .system(.largeTitle, design: .rounded))
        Divider()
        ScrollView(.vertical, showsIndicators: true) {
          LazyVGrid(columns: columns, spacing: 20) {
            ForEach(harvest.yields) { yield in
              ZStack {
                PlantCard(species: yield.species, showsGenotypes: lesson.showsGenotypes)
                if newIDs.contains(yield.id) {
                  Image("new")
                    .resizable()
                    .scaledToFit()
                    .offset(x: 5, y: lesson.showsGenotypes ? -65 : -40)
                    .frame(width: 60)
                    .rotationEffect(.degrees(30))
                }
              }
            }
          }
        }
        .frame(height: 450)
        Spacer()
        if let next = lesson.next {
          NavigationLink(destination: InstructionView(lesson: next)) {
            LabButtonLabel(title: "OK")
          }
        } else {
          Button {
            withAnimation(.easeInOut) { showSucceedView = false }
          } label: {
            LabButtonLabel(title: "OK")
          }
        }
      }
      .padding()
      .foregroundColor(.white)
    }
    .frame(width: 600, height: 650)
    .shadow(radius: 20)
  }
}
