import SwiftUI

struct PlantGenotypeView: View {
  let species: PlantSpecies

  var body: some View {
    ZStack {
      Image("factors").resizable().scaledToFit()
      Text(species.plant?.notation ?? "?")
        .font(.system(.largeTitle, design: .monospaced))
        .foregroundColor(.black)
    }
    .frame(width: 200, height: 200)
    .transition(.opacity)
  }
}

struct GametesView: View {
  let gametes: [Gamete]

  var body: some View {
    VStack(spacing: 50) {
      ForEach(gametes.indices, id: \.self) { index in
        ZStack {
          Image("factor").resizable().scaledToFit()
          Text(gametes[index].notation)
            .font(.system(.headline, design: .monospaced))
            .foregroundColor(.black)
        }
        .frame(width: 50, height: 50)
      }
    }
  }
}

struct OffspringView: View {
  let firstGametes: [Gamete]
  let secondGametes: [Gamete]

  private var offspring: [PlantSpecies] {
    zip(firstGametes, secondGametes).compactMap { first, second in
      Plant.combining(first, second).flatMap(PlantCatalog.species(for:))
    }
  }

  var body: some View {
    VStack {
      ForEach(Array(offspring.enumerated()), id: \.offset) { _, species in
        ZStack {
          Image(species.imageName).resizable().scaledToFit()
          GenotypeBadge(notation: species.plant?.notation ?? "?", height: 30)
            .offset(x: 30, y: 30)
        }
        .frame(width: 100, height: 100)
      }
    }
    .transition(.opacity)
  }
}
