import Foundation

/// Asset names belong to catalog data; the genetics model has no SwiftUI dependency.
struct PlantSpecies: Identifiable, Hashable {
  let id: Int
  let name: String
  let imageName: String
  let plant: Plant?

  static func == (lhs: Self, rhs: Self) -> Bool { lhs.id == rhs.id }
  func hash(into hasher: inout Hasher) { hasher.combine(id) }

  static let unknown = PlantSpecies(id: 99, name: "unknown", imageName: "questionmark", plant: nil)
}

enum PlantCatalog {
  // Preserve the original IDs, including the different ordering in the two-trait chapter.
  static let all: [PlantSpecies] = {
    let d = Genotype.Zygosity.homozygousDominant
    let h = Genotype.Zygosity.heterozygous
    let r = Genotype.Zygosity.homozygousRecessive
    let single = [r, d, h].map { [Genotype(symbol: "a", zygosity: $0)] }
    let double = [d, h, r].flatMap { shape in
      [d, h, r].map { color in
        [Genotype(symbol: "a", zygosity: color), Genotype(symbol: "b", zygosity: shape)]
      }
    }
    let triple = [d, h, r].flatMap { color in
      [d, h, r].flatMap { shape in
        [d, h, r].map { health in
          [
            Genotype(symbol: "a", zygosity: color),
            Genotype(symbol: "b", zygosity: shape),
            Genotype(symbol: "c", zygosity: health),
          ]
        }
      }
    }
    return (single + double + triple).enumerated().map { index, genotypes in
      let color = genotypes[0].expressesDominantTrait ? "red" : "yellow"
      let shape =
        genotypes.count < 2 || genotypes[1].expressesDominantTrait ? "round" : "pear-shaped"
      let health =
        genotypes.count < 3 || genotypes[2].expressesDominantTrait ? "healthy" : "disease"
      let name: String
      switch genotypes.count {
      case 1: name = "\(color.capitalized) 🍅"
      case 2: name = "\(color.capitalized) \(shape == "round" ? "Round" : "Pear-Shaped") 🍅"
      default: name = "\(color) \(shape) \(health) 🍅"
      }
      return PlantSpecies(
        id: index + 1, name: name,
        imageName: "\(color)_\(shape)_\(health)",
        plant: Plant(genotypes: genotypes))
    }
  }()

  private static let byID = Dictionary(uniqueKeysWithValues: all.map { ($0.id, $0) })
  private static let byGenotype = Dictionary(
    uniqueKeysWithValues: all.compactMap { species in
      species.plant.map { ($0.notation, species) }
    })

  static func species(id: Int) -> PlantSpecies? { byID[id] }

  static func species(for plant: Plant) -> PlantSpecies? {
    guard let species = byGenotype[plant.notation] else { return nil }
    // The original offspring initializer used this asset for aa, while its seed card
    // used yellow_round_healthy. Preserve that visible behavior during this refactor.
    guard species.id == 1 else { return species }
    return PlantSpecies(
      id: species.id, name: species.name,
      imageName: "yellow_pear-shaped_healthy", plant: plant)
  }
}
