import Foundation

/// The experiment's rules and transitions, independent of rendering and animation timing.
struct Experiment {
  enum Phase { case planting, growing, explaining, harvest }
  enum AnimationStage: Int {
    case ready, genotypes, gametes, pollination, offspring
  }
  enum Notice {
    case incorrectParents, missingParents, completedCollection

    var message: String {
      switch self {
      case .incorrectParents:
        return
          "Please follow the instructions for sowing the correct variety of tomatoes! In the final chapter you will be able to combine freely!"
      case .missingParents:
        return "Please plant the tomato seeds on both 2 lands!"
      case .completedCollection:
        return
          "You've managed to collect all the varieties of tomatoes! You have learned the most important principle about genetics!"
      }
    }
  }

  let lesson: Lesson
  private(set) var inventory: [PlantSpecies]
  private(set) var firstParent: PlantSpecies?
  private(set) var secondParent: PlantSpecies?
  private(set) var phase = Phase.planting
  private(set) var animationStage = AnimationStage.ready
  private(set) var harvest: Harvest?
  private(set) var newSpeciesIDs: Set<Int> = []
  private(set) var firstGametes: [Gamete] = []
  private(set) var secondGametes: [Gamete] = []
  private(set) var hasCompletedCollection = false
  var notice: Notice?
  private var completionPending = false

  init(lesson: Lesson) {
    self.lesson = lesson
    inventory = lesson.initialSpecies
  }

  var canSelectParents: Bool { phase == .planting && notice == nil }
  var unknownCount: Int {
    lesson.isFreeCombination
      ? max(0, lesson.collectibleCount - inventory.count) : lesson.initialUnknownCount
  }
  var title: String {
    lesson.hasAnimation && (phase == .explaining || phase == .harvest) ? "" : lesson.title
  }
  var instruction: String {
    guard lesson.hasAnimation, phase == .explaining || phase == .harvest else {
      return lesson.instruction
    }
    guard animationStage != .ready else {
      return "Tap the play button to see how the new seeds are created!"
    }
    return lesson.animationInstructions[animationStage.rawValue - 1]
  }

  mutating func select(_ species: PlantSpecies?, forFirstParent: Bool) {
    guard canSelectParents else { return }
    guard species == nil || inventory.contains(where: { $0.id == species?.id }) else { return }
    if forFirstParent { firstParent = species } else { secondParent = species }
  }

  mutating func resetParents() {
    guard canSelectParents else { return }
    firstParent = nil
    secondParent = nil
  }

  @discardableResult
  mutating func beginCross<R: RandomNumberGenerator>(using generator: inout R) -> Bool {
    guard canSelectParents else { return false }
    guard let first = firstParent, let second = secondParent else {
      notice = .missingParents
      return false
    }
    guard lesson.isFreeCombination || first != second else {
      resetParents()
      notice = .incorrectParents
      return false
    }
    guard let result = Breeding.cross(first, second, using: &generator) else {
      notice = .incorrectParents
      return false
    }
    harvest = result
    newSpeciesIDs = Set(result.yields.map(\.id)).subtracting(inventory.map(\.id))
    firstGametes = Breeding.animationSamples(from: first, using: &generator)
    secondGametes = Breeding.animationSamples(from: second, using: &generator)
    animationStage = .ready
    phase = .growing
    return true
  }

  mutating func finishGrowing() {
    guard phase == .growing else { return }
    if lesson.hasAnimation {
      phase = .explaining
    } else {
      presentHarvest()
    }
  }

  mutating func advanceAnimation() {
    guard phase == .explaining else { return }
    if let next = AnimationStage(rawValue: animationStage.rawValue + 1) {
      animationStage = next
    } else {
      presentHarvest()
    }
  }

  private mutating func presentHarvest() {
    if lesson.isFreeCombination, let harvest = harvest {
      inventory.append(
        contentsOf: harvest.yields.map(\.species).filter { newSpeciesIDs.contains($0.id) })
      if unknownCount == 0 && !hasCompletedCollection {
        hasCompletedCollection = true
        completionPending = true
      }
      firstParent = nil
      secondParent = nil
    }
    phase = .harvest
  }

  mutating func dismissHarvest() {
    guard phase == .harvest, lesson.isFreeCombination else { return }
    phase = .planting
    if completionPending {
      notice = .completedCollection
      completionPending = false
    }
  }

  mutating func cancelGrowth() {
    guard phase == .growing else { return }
    phase = .planting
    harvest = nil
    newSpeciesIDs = []
  }
}
