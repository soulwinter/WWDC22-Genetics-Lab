import SwiftUI

@MainActor
final class ExperimentViewModel: ObservableObject {
  struct FallingTomato: Identifiable {
    let id: Int
    let imageName: String
    let x: CGFloat
    let duration: Double
  }

  @Published var experiment: Experiment
  @Published private(set) var growthStage = 1
  @Published private(set) var fallingTomatoes: [FallingTomato] = []
  private var growthTask: Task<Void, Never>?

  init(lesson: Lesson) {
    experiment = Experiment(lesson: lesson)
  }

  func parentBinding(first: Bool) -> Binding<PlantSpecies?> {
    Binding(
      get: { first ? self.experiment.firstParent : self.experiment.secondParent },
      set: { self.experiment.select($0, forFirstParent: first) }
    )
  }

  var harvestPresented: Binding<Bool> {
    Binding(
      get: { self.experiment.phase == .harvest },
      set: { presented in
        if !presented { self.experiment.dismissHarvest() }
      })
  }

  func cross() {
    var generator = SystemRandomNumberGenerator()
    let started = withAnimation(.easeInOut) { experiment.beginCross(using: &generator) }
    guard started else { return }
    fallingTomatoes = []
    growthStage = 1
    growthTask?.cancel()
    growthTask = Task { [weak self] in
      do {
        // Preserve the original growth frames at 0.3, 0.6, 1.0 and 1.3 seconds.
        for delay in [300_000_000, 300_000_000, 400_000_000] {
          try await Task.sleep(nanoseconds: UInt64(delay))
          guard let self = self else { return }
          withAnimation(.easeInOut) { self.growthStage += 1 }
        }
        try await Task.sleep(nanoseconds: 300_000_000)
        guard let self = self else { return }
        withAnimation(.easeInOut) {
          self.experiment.finishGrowing()
          if self.experiment.lesson.isFreeCombination { self.growthStage = 1 }
        }
        if self.experiment.phase == .harvest { self.celebrate() }
      } catch {
        // Leaving the chapter cancels pending UI updates.
      }
    }
  }

  func advanceAnimation() {
    guard experiment.phase == .explaining else { return }
    let duration: Double
    switch experiment.animationStage {
    case .gametes: duration = 2
    case .pollination: duration = 0.5
    default: duration = 1
    }
    withAnimation(.easeInOut(duration: duration)) { experiment.advanceAnimation() }
    if experiment.phase == .harvest { celebrate() }
  }

  func stop() {
    growthTask?.cancel()
    growthTask = nil
    experiment.cancelGrowth()
    growthStage = 1
  }

  private func celebrate() {
    guard let yields = experiment.harvest?.yields, !yields.isEmpty else { return }
    let width = UIScreen.main.bounds.width
    for index in 0..<80 {
      guard let species = yields.randomElement()?.species else { continue }
      let tomato = FallingTomato(
        id: index, imageName: PlantCatalog.species(id: species.id)?.imageName ?? species.imageName,
        x: CGFloat.random(in: -500...width + 500),
        duration: Double.random(in: 3...5))
      withAnimation(.easeIn(duration: tomato.duration)) {
        fallingTomatoes.append(tomato)
      }
    }
  }
}
