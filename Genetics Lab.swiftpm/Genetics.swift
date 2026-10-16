import Foundation

/// One allele of a gene. A gamete contains one allele for each trait.
struct Allele: Hashable {
  enum Dominance: CaseIterable {
    case recessive, dominant
  }

  let symbol: String
  let dominance: Dominance

  var notation: String {
    dominance == .dominant ? symbol.uppercased() : symbol.lowercased()
  }
}

struct Genotype: Hashable {
  enum Zygosity: CaseIterable {
    case homozygousDominant, heterozygous, homozygousRecessive
  }

  let symbol: String
  let zygosity: Zygosity

  var alleles: [Allele] {
    let dominant = Allele(symbol: symbol, dominance: .dominant)
    let recessive = Allele(symbol: symbol, dominance: .recessive)
    switch zygosity {
    case .homozygousDominant: return [dominant, dominant]
    case .heterozygous: return [dominant, recessive]
    case .homozygousRecessive: return [recessive, recessive]
    }
  }

  var notation: String { alleles.map(\.notation).joined() }
  var expressesDominantTrait: Bool { zygosity != .homozygousRecessive }

  init(symbol: String, zygosity: Zygosity) {
    self.symbol = symbol.lowercased()
    self.zygosity = zygosity
  }

  init?(_ first: Allele, _ second: Allele) {
    guard first.symbol == second.symbol else { return nil }
    symbol = first.symbol
    switch (first.dominance, second.dominance) {
    case (.dominant, .dominant): zygosity = .homozygousDominant
    case (.recessive, .recessive): zygosity = .homozygousRecessive
    default: zygosity = .heterozygous
    }
  }

  func randomAllele<R: RandomNumberGenerator>(using generator: inout R) -> Allele {
    // Homozygotes do not need a random draw.
    guard zygosity == .heterozygous else { return alleles[0] }
    return alleles[Int.random(in: 0...1, using: &generator)]
  }
}

struct Gamete: Hashable {
  let alleles: [Allele]
  var notation: String { alleles.map(\.notation).joined() }
}

struct Plant: Hashable {
  let genotypes: [Genotype]
  var notation: String { genotypes.map(\.notation).joined() }

  func randomGamete<R: RandomNumberGenerator>(using generator: inout R) -> Gamete {
    Gamete(alleles: genotypes.map { $0.randomAllele(using: &generator) })
  }

  static func combining(_ first: Gamete, _ second: Gamete) -> Plant? {
    guard !first.alleles.isEmpty, first.alleles.count == second.alleles.count else { return nil }
    let genotypes = zip(first.alleles, second.alleles).compactMap { Genotype($0, $1) }
    guard genotypes.count == first.alleles.count else { return nil }
    return Plant(genotypes: genotypes)
  }
}

struct Harvest {
  struct Yield: Identifiable {
    let species: PlantSpecies
    let count: Int
    var id: Int { species.id }
  }

  let yields: [Yield]
  var totalCount: Int { yields.reduce(0) { $0 + $1.count } }
}

enum Breeding {
  static func cross<R: RandomNumberGenerator>(
    _ first: PlantSpecies, _ second: PlantSpecies, using generator: inout R
  ) -> Harvest? {
    guard let firstPlant = first.plant, let secondPlant = second.plant,
      firstPlant.genotypes.map(\.symbol) == secondPlant.genotypes.map(\.symbol)
    else { return nil }

    let count = Int.random(in: 40...150, using: &generator)
    var counts: [PlantSpecies: Int] = [:]
    for _ in 0..<count {
      guard
        let child = Plant.combining(
          firstPlant.randomGamete(using: &generator),
          secondPlant.randomGamete(using: &generator)
        ), let species = PlantCatalog.species(for: child)
      else { return nil }
      counts[species, default: 0] += 1
    }
    // Keep each count with its species, and give SwiftUI stable identities and ordering.
    return Harvest(
      yields: counts.map { Harvest.Yield(species: $0.key, count: $0.value) }
        .sorted { $0.id < $1.id })
  }

  static func animationSamples<R: RandomNumberGenerator>(
    from species: PlantSpecies, using generator: inout R
  ) -> [Gamete] {
    guard let plant = species.plant else { return [] }
    return (0..<3).map { _ in plant.randomGamete(using: &generator) }
  }
}
