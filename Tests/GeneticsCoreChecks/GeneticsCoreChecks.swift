import Foundation

private struct SeededGenerator: RandomNumberGenerator {
  var state: UInt64
  mutating func next() -> UInt64 {
    state &+= 0x9E37_79B9_7F4A_7C15
    var value = state
    value = (value ^ (value >> 30)) &* 0xBF58_476D_1CE4_E5B9
    value = (value ^ (value >> 27)) &* 0x94D0_49BB_1331_11EB
    return value ^ (value >> 31)
  }
}

struct GeneticsCoreChecks {
  private struct OriginalSpecies: Decodable {
    let id: Int
    let name: String
    let image: String
    let genotype: String
    let offspringImage: String?
  }

  func testCatalogMatchesOriginalIDsNamesGenotypesAndBothImageMappings() throws {
    let url = fixtureURL("OriginalCatalog.json")
    let original = try JSONDecoder().decode([OriginalSpecies].self, from: Data(contentsOf: url))
    try expectEqual(PlantCatalog.all.count, 39)
    for expected in original {
      let species = try unwrap(
        expected.id == 99 ? PlantSpecies.unknown : PlantCatalog.species(id: expected.id))
      try expectEqual(species.name, expected.name)
      try expectEqual(species.imageName, expected.image)
      try expectEqual(species.plant?.notation ?? "", expected.genotype)
      if let plant = species.plant {
        let offspring = try unwrap(PlantCatalog.species(for: plant))
        try expectEqual(offspring.id, expected.id)
        try expectEqual(offspring.imageName, expected.offspringImage)
        try expectEqual(offspring.name, expected.name)
      }
    }
    try expectNil(PlantCatalog.species(id: 0))
    try expectNil(PlantCatalog.species(id: 99))
  }

  func testAlleleCombinationIsOrderIndependentAndRejectsIncompatibleGametes() throws {
    let dominant = Allele(symbol: "a", dominance: .dominant)
    let recessive = Allele(symbol: "a", dominance: .recessive)
    try expectEqual(Genotype(dominant, recessive)?.notation, "Aa")
    try expectEqual(Genotype(recessive, dominant)?.notation, "Aa")
    try expectEqual(Genotype(dominant, dominant)?.notation, "AA")
    try expectEqual(Genotype(recessive, recessive)?.notation, "aa")
    let wrongTrait = Allele(symbol: "b", dominance: .dominant)
    try expectNil(Genotype(dominant, wrongTrait))
    try expectNil(Plant.combining(Gamete(alleles: []), Gamete(alleles: [])))
    try expectNil(Plant.combining(Gamete(alleles: [dominant]), Gamete(alleles: [])))
    try expectNil(Plant.combining(Gamete(alleles: [dominant]), Gamete(alleles: [wrongTrait])))
    var generator = SeededGenerator(state: 1)
    try expectNil(Breeding.cross(.unknown, PlantCatalog.all[0], using: &generator))
    try expectNil(Breeding.cross(PlantCatalog.all[0], PlantCatalog.all[3], using: &generator))
  }

  func testEveryCompatibleParentPairProducesOnlyMendelianOffspringAnd40To150Fruits() throws {
    var generator = SeededGenerator(state: 42)
    for first in PlantCatalog.all {
      for second in PlantCatalog.all
      where first.plant?.genotypes.count == second.plant?.genotypes.count {
        let firstPlant = try unwrap(first.plant)
        let secondPlant = try unwrap(second.plant)
        let result = try unwrap(Breeding.cross(first, second, using: &generator))
        try expectTrue((40...150).contains(result.totalCount))
        try expectEqual(result.yields.map(\.id), result.yields.map(\.id).sorted())
        try expectEqual(result.yields.count, Set(result.yields.map(\.id)).count)
        for yield in result.yields {
          try expectGreaterThan(yield.count, 0)
          let child = try unwrap(yield.species.plant)
          try expectEqual(child.genotypes.count, firstPlant.genotypes.count)
          for index in child.genotypes.indices {
            let possible = Set(
              firstPlant.genotypes[index].alleles.flatMap { firstAllele in
                secondPlant.genotypes[index].alleles.compactMap { Genotype(firstAllele, $0) }
              })
            try expectTrue(possible.contains(child.genotypes[index]))
          }
        }
      }
    }
  }

  func testSegregationAndIndependentAssortmentDistributions() throws {
    var generator = SeededGenerator(state: 2022)
    func distribution(_ firstID: Int, _ secondID: Int) throws -> [Int: Double] {
      let first = try unwrap(PlantCatalog.species(id: firstID))
      let second = try unwrap(PlantCatalog.species(id: secondID))
      var counts: [Int: Int] = [:]
      for _ in 0..<500 {
        let result = try unwrap(Breeding.cross(first, second, using: &generator))
        for yield in result.yields { counts[yield.id, default: 0] += yield.count }
      }
      let total = Double(counts.values.reduce(0, +))
      return counts.mapValues { Double($0) / total }
    }
    try expectEqual(try distribution(2, 1), [3: 1])  // AA x aa -> Aa only
    let segregation = try distribution(3, 3)
    for (id, probability) in [1: 0.25, 2: 0.25, 3: 0.5] {
      try expectEqual(try unwrap(segregation[id]), probability, accuracy: 0.02)
    }
    let assortment = try distribution(8, 12)
    try expectEqual(Set(assortment.keys), Set([8, 9, 11, 12]))
    for probability in assortment.values { try expectEqual(probability, 0.25, accuracy: 0.02) }
  }

  func testAnimationSamplesUseParentalAllelesAndHaveThreeRows() throws {
    var generator = SeededGenerator(state: 18)
    for species in PlantCatalog.all {
      let plant = try unwrap(species.plant)
      let samples = Breeding.animationSamples(from: species, using: &generator)
      try expectEqual(samples.count, 3)
      for gamete in samples {
        try expectEqual(gamete.alleles.count, plant.genotypes.count)
        for index in gamete.alleles.indices {
          try expectTrue(plant.genotypes[index].alleles.contains(gamete.alleles[index]))
        }
      }
    }
    try expectTrue(Breeding.animationSamples(from: .unknown, using: &generator).isEmpty)
  }

  func testAllFiveLessonConfigurationsAndNavigation() throws {
    let copy = try JSONDecoder().decode(
      [String: [String]].self, from: Data(contentsOf: fixtureURL("OriginalLessons.json")))
    try expectEqual(Lesson.allCases.map(\.title), copy["titles"])
    try expectEqual(Lesson.allCases.map(\.instruction), copy["instructions"])
    try expectEqual(Lesson.inDepth.animationInstructions, copy["segregation"])
    try expectEqual(Lesson.whatHappened.animationInstructions, copy["assortment"])

    try expectEqual(
      Lesson.allCases.map { $0.initialSpecies.map(\.id) },
      [[2, 1], [2, 1], [8, 12], [8, 12], [21, 33, 37]])
    try expectEqual(Lesson.allCases.map(\.hasAnimation), [false, true, false, true, false])
    try expectEqual(Lesson.allCases.map(\.showsGenotypes), [false, true, true, true, true])
    try expectEqual(Lesson.allCases.map(\.isFreeCombination), [false, false, false, false, true])
    for lesson in Lesson.allCases {
      try expectFalse(lesson.title.isEmpty)
      try expectFalse(lesson.instruction.isEmpty)
      try expectEqual(lesson.next?.rawValue, lesson == .cultivate ? nil : lesson.rawValue + 1)
      try expectEqual(Experiment(lesson: lesson).unknownCount, 24)
      try expectEqual(lesson.animationInstructions.count, lesson.hasAnimation ? 4 : 0)
    }
  }

  func testGuidedValidationAndGrowthLock() throws {
    var experiment = Experiment(lesson: .firstLesson)
    var generator = SeededGenerator(state: 4)
    try expectFalse(experiment.beginCross(using: &generator))
    try expectEqual(experiment.notice, .missingParents)
    experiment.notice = nil
    experiment.select(.unknown, forFirstParent: true)
    try expectNil(experiment.firstParent)
    experiment.select(PlantCatalog.species(id: 26), forFirstParent: true)
    try expectNil(experiment.firstParent)
    experiment.select(PlantCatalog.species(id: 2), forFirstParent: true)
    experiment.select(PlantCatalog.species(id: 2), forFirstParent: false)
    try expectFalse(experiment.beginCross(using: &generator))
    try expectEqual(experiment.notice, .incorrectParents)
    try expectNil(experiment.firstParent)
    try expectNil(experiment.secondParent)
    experiment.notice = nil
    experiment.select(PlantCatalog.species(id: 2), forFirstParent: true)
    experiment.select(PlantCatalog.species(id: 1), forFirstParent: false)
    try expectTrue(experiment.beginCross(using: &generator))
    try expectEqual(experiment.phase, .growing)
    try expectFalse(experiment.beginCross(using: &generator))
    experiment.resetParents()
    experiment.select(PlantCatalog.species(id: 1), forFirstParent: true)
    try expectEqual(experiment.firstParent?.id, 2)
    experiment.finishGrowing()
    try expectEqual(experiment.phase, .harvest)
    try expectEqual(experiment.harvest?.yields.map(\.id), [3])
    try expectEqual(experiment.newSpeciesIDs, [3])
    try expectEqual(experiment.inventory.map(\.id), [2, 1])
    experiment.dismissHarvest()
    try expectEqual(experiment.phase, .harvest)  // guided chapters proceed through navigation
  }

  func testAnimatedChaptersAdvanceThroughExactlyFourExplanationsBeforeHarvest() throws {
    var generator = SeededGenerator(state: 10)
    for lesson in [Lesson.inDepth, .whatHappened] {
      var experiment = Experiment(lesson: lesson)
      experiment.select(lesson.initialSpecies[0], forFirstParent: true)
      experiment.select(lesson.initialSpecies[1], forFirstParent: false)
      experiment.advanceAnimation()
      try expectEqual(experiment.phase, .planting)
      try expectTrue(experiment.beginCross(using: &generator))
      experiment.finishGrowing()
      try expectEqual(experiment.phase, .explaining)
      try expectEqual(experiment.animationStage, .ready)
      try expectEqual(experiment.title, "")
      try expectTrue(experiment.instruction.contains("Tap the play button"))
      for (index, text) in lesson.animationInstructions.enumerated() {
        experiment.advanceAnimation()
        try expectEqual(experiment.animationStage.rawValue, index + 1)
        try expectEqual(experiment.instruction, text)
        try expectEqual(experiment.phase, .explaining)
      }
      experiment.advanceAnimation()
      try expectEqual(experiment.phase, .harvest)
      experiment.advanceAnimation()
      try expectEqual(experiment.phase, .harvest)
    }
  }

  func testCancelledGrowthCanBeRestarted() throws {
    var experiment = Experiment(lesson: .inDepth)
    var generator = SeededGenerator(state: 9)
    experiment.select(PlantCatalog.species(id: 2), forFirstParent: true)
    experiment.select(PlantCatalog.species(id: 1), forFirstParent: false)
    try expectTrue(experiment.beginCross(using: &generator))
    experiment.cancelGrowth()
    experiment.finishGrowing()
    try expectEqual(experiment.phase, .planting)
    try expectNil(experiment.harvest)
    try expectTrue(experiment.newSpeciesIDs.isEmpty)
    try expectTrue(experiment.beginCross(using: &generator))
    experiment.finishGrowing()
    try expectEqual(experiment.phase, .explaining)
  }

  func testFreeBreedingCollectsAll27VarietiesWithoutDuplicatesAndCompletesOnce() throws {
    var experiment = Experiment(lesson: .cultivate)
    var generator = SeededGenerator(state: 88)
    func cross(_ firstID: Int, _ secondID: Int) throws {
      let previous = Set(experiment.inventory.map(\.id))
      experiment.select(PlantCatalog.species(id: firstID), forFirstParent: true)
      experiment.select(PlantCatalog.species(id: secondID), forFirstParent: false)
      try expectTrue(experiment.beginCross(using: &generator))
      let harvest = try unwrap(experiment.harvest)
      try expectEqual(experiment.newSpeciesIDs, Set(harvest.yields.map(\.id)).subtracting(previous))
      experiment.finishGrowing()
      try expectEqual(experiment.phase, .harvest)
      try expectNil(experiment.firstParent)
      try expectNil(experiment.secondParent)
      try expectEqual(experiment.inventory.count, Set(experiment.inventory.map(\.id)).count)
      try expectEqual(experiment.unknownCount, 27 - experiment.inventory.count)
      experiment.dismissHarvest()
      try expectEqual(experiment.phase, .planting)
    }
    try cross(21, 33)  // AAbbcc x aaBBcc -> AaBbcc
    try cross(27, 37)  // AaBbcc x aabbCC -> includes AaBbCc
    try expectTrue(experiment.inventory.contains { $0.id == 26 })
    for _ in 0..<100 where !experiment.hasCompletedCollection { try cross(26, 26) }
    try expectEqual(Set(experiment.inventory.map(\.id)), Set(13...39))
    try expectTrue(experiment.hasCompletedCollection)
    try expectEqual(experiment.unknownCount, 0)
    try expectEqual(experiment.notice, .completedCollection)
    experiment.notice = nil
    try cross(26, 26)
    try expectNil(experiment.notice)
  }
}

@main
struct CheckRunner {
  static func main() throws {
    let checks = GeneticsCoreChecks()
    try checks.testCatalogMatchesOriginalIDsNamesGenotypesAndBothImageMappings()
    print("PASS testCatalogMatchesOriginalIDsNamesGenotypesAndBothImageMappings")
    try checks.testAlleleCombinationIsOrderIndependentAndRejectsIncompatibleGametes()
    print("PASS testAlleleCombinationIsOrderIndependentAndRejectsIncompatibleGametes")
    try checks.testEveryCompatibleParentPairProducesOnlyMendelianOffspringAnd40To150Fruits()
    print("PASS testEveryCompatibleParentPairProducesOnlyMendelianOffspringAnd40To150Fruits")
    try checks.testSegregationAndIndependentAssortmentDistributions()
    print("PASS testSegregationAndIndependentAssortmentDistributions")
    try checks.testAnimationSamplesUseParentalAllelesAndHaveThreeRows()
    print("PASS testAnimationSamplesUseParentalAllelesAndHaveThreeRows")
    try checks.testAllFiveLessonConfigurationsAndNavigation()
    print("PASS testAllFiveLessonConfigurationsAndNavigation")
    try checks.testGuidedValidationAndGrowthLock()
    print("PASS testGuidedValidationAndGrowthLock")
    try checks.testAnimatedChaptersAdvanceThroughExactlyFourExplanationsBeforeHarvest()
    print("PASS testAnimatedChaptersAdvanceThroughExactlyFourExplanationsBeforeHarvest")
    try checks.testCancelledGrowthCanBeRestarted()
    print("PASS testCancelledGrowthCanBeRestarted")
    try checks.testFreeBreedingCollectsAll27VarietiesWithoutDuplicatesAndCompletesOnce()
    print("PASS testFreeBreedingCollectsAll27VarietiesWithoutDuplicatesAndCompletesOnce")
    print("All 10 core checks passed.")
  }
}

private struct CheckFailure: Error, CustomStringConvertible {
  let description: String
}

private func expectTrue(_ value: Bool, file: StaticString = #filePath, line: UInt = #line) throws {
  guard value else { throw CheckFailure(description: "\(file):\(line): expected true") }
}

private func expectFalse(_ value: Bool, file: StaticString = #filePath, line: UInt = #line) throws {
  try expectTrue(!value, file: file, line: line)
}

private func expectNil<T>(_ value: T?, file: StaticString = #filePath, line: UInt = #line) throws {
  try expectTrue(value == nil, file: file, line: line)
}

private func expectEqual<T: Equatable>(
  _ actual: T, _ expected: T, file: StaticString = #filePath, line: UInt = #line
) throws {
  guard actual == expected else {
    throw CheckFailure(description: "\(file):\(line): \(actual) != \(expected)")
  }
}

private func expectEqual(
  _ actual: Double, _ expected: Double, accuracy: Double, file: StaticString = #filePath,
  line: UInt = #line
) throws {
  try expectTrue(abs(actual - expected) <= accuracy, file: file, line: line)
}

private func expectGreaterThan<T: Comparable>(
  _ actual: T, _ lowerBound: T, file: StaticString = #filePath, line: UInt = #line
) throws {
  try expectTrue(actual > lowerBound, file: file, line: line)
}

private func unwrap<T>(_ value: T?, file: StaticString = #filePath, line: UInt = #line) throws -> T
{
  guard let value = value else {
    throw CheckFailure(description: "\(file):\(line): unexpected nil")
  }
  return value
}

private func fixtureURL(_ name: String) -> URL {
  URL(fileURLWithPath: #filePath).deletingLastPathComponent()
    .appendingPathComponent("Fixtures").appendingPathComponent(name)
}
