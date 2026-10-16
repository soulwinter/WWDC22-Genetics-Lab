import SwiftUI

struct GenotypeBadge: View {
  let notation: String
  var height: CGFloat = 50

  var body: some View {
    ZStack {
      Image("show_factors")
        .resizable()
        .scaledToFit()
        .frame(height: height)
      Text(notation)
        .font(.system(.body, design: .monospaced))
        .foregroundColor(.black)
    }
  }
}

struct PlantCard: View {
  let species: PlantSpecies
  let showsGenotypes: Bool
  var isDraggable = true

  var body: some View {
    if species.plant != nil && isDraggable {
      card.onDrag { NSItemProvider(object: String(species.id) as NSString) }
    } else {
      card
    }
  }

  private var card: some View {
    VStack(spacing: 0) {
      ZStack {
        Image("canva")
          .resizable()
          .scaledToFit()
          .frame(width: 100, height: 100)
        Image(species.imageName)
          .resizable()
          .scaledToFit()
          .frame(width: 80, height: 80)
      }
      if showsGenotypes { GenotypeBadge(notation: species.plant?.notation ?? "?") }
    }
  }
}

struct PlantPlot: View {
  @Binding var selected: PlantSpecies?
  let growthStage: Int
  let showsGenotypes: Bool
  let acceptsDrops: Bool
  let availableIDs: Set<Int>

  var body: some View {
    ZStack {
      Image("dirt")
        .resizable()
        .scaledToFit()
        .onDrop(
          of: ["public.text"],
          delegate: PlantDropDelegate(
            selection: $selected, availableIDs: availableIDs, isEnabled: acceptsDrops
          ))
      if let species = selected {
        if showsGenotypes {
          PlantGenotypeView(species: species)
        } else {
          Image("grow\(growthStage)")
            .resizable()
            .scaledToFit()
            .offset(y: -20)
            .transition(.opacity)
        }
      }
    }
    .frame(width: 250, height: 250)
  }
}

struct LabButtonLabel: View {
  let title: String
  var imageName = "common_button"
  var font: Font = .system(.title, design: .rounded)

  var body: some View {
    ZStack {
      Image(imageName).resizable().scaledToFit()
      Text(title).font(font).foregroundColor(.black)
    }
    .frame(width: 200)
  }
}
