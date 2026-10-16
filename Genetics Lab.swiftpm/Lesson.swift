import Foundation

enum Lesson: Int, CaseIterable, Identifiable {
  case firstLesson, inDepth, multipleTraits, whatHappened, cultivate

  var id: Int { rawValue }
  var title: String { LessonContent.titles[rawValue] }
  var instruction: String { LessonContent.instructions[rawValue] }
  var showsGenotypes: Bool { self != .firstLesson }
  var isFreeCombination: Bool { self == .cultivate }
  var next: Lesson? { Lesson(rawValue: rawValue + 1) }

  var animationInstructions: [String] {
    switch self {
    case .inDepth: return LessonContent.animations[0]
    case .whatHappened: return LessonContent.animations[1]
    default: return []
    }
  }

  var hasAnimation: Bool { !animationInstructions.isEmpty }

  var initialSpecies: [PlantSpecies] {
    let ids: [Int]
    switch self {
    case .firstLesson, .inDepth: ids = [2, 1]
    case .multipleTraits, .whatHappened: ids = [8, 12]
    case .cultivate: ids = [21, 33, 37]
    }
    return ids.compactMap(PlantCatalog.species(id:))
  }

  var collectibleCount: Int { 27 }
  // The guided chapters originally display 24 unknown cards beside the two parents.
  var initialUnknownCount: Int { 24 }
}
