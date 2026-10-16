import SwiftUI

@MainActor
struct InstructionView: View {
  @StateObject private var model: ExperimentViewModel
  @State private var textHeight: CGFloat = 200

  init(lesson: Lesson) {
    _model = StateObject(wrappedValue: ExperimentViewModel(lesson: lesson))
  }

  private var experiment: Experiment { model.experiment }

  var body: some View {
    ZStack {
      Color(hex: 0x666633).ignoresSafeArea()
      header
      VStack {
        Spacer()
        controls
        seedShelf
      }
      .padding()
      experimentAnimation
      tomatoRain
    }
    .popup(isPresented: model.harvestPresented) {
      if let harvest = experiment.harvest {
        SucceedView(
          harvest: harvest, newIDs: experiment.newSpeciesIDs,
          lesson: experiment.lesson, showSucceedView: model.harvestPresented
        )
        .transition(.scale)
      }
    }
    .popup(
      isPresented: Binding(
        get: { model.experiment.notice != nil },
        set: { if !$0 { model.experiment.notice = nil } }
      )
    ) {
      if let notice = experiment.notice {
        FailView(notice: notice) {
          withAnimation(.easeInOut) { model.experiment.notice = nil }
        }
        .transition(.scale)
      }
    }
    .navigationBarTitle("")
    .navigationBarBackButtonHidden(true)
    .navigationBarHidden(true)
    .onDisappear { model.stop() }
  }

  private var header: some View {
    VStack {
      ZStack {
        Rectangle().foregroundColor(Color(hex: 0x147B0F))
        VStack(alignment: .leading, spacing: 6) {
          Text(experiment.title)
            .font(.system(size: 50, weight: .heavy, design: .rounded))
          Text(.init(experiment.instruction)).font(.body)
        }
        .foregroundColor(.white)
        .padding()
        .background(
          GeometryReader { geometry in
            Color.clear.onAppear { textHeight = geometry.size.height }
          })
      }
      .frame(height: textHeight + 60)
      .ignoresSafeArea()
      Spacer()
    }
  }

  @ViewBuilder
  private var controls: some View {
    if experiment.phase == .planting || experiment.phase == .growing {
      HStack(spacing: 30) {
        Button {
          model.experiment.resetParents()
        } label: {
          LabButtonLabel(
            title: "Reset", imageName: "reset_button",
            font: .system(.largeTitle, design: .rounded))
        }
        Button {
          model.cross()
        } label: {
          LabButtonLabel(
            title: "Cross", imageName: "combine_button",
            font: .system(.largeTitle, design: .rounded))
        }
      }
      .disabled(!experiment.canSelectParents)
      .transition(.scale)
    } else if experiment.lesson.hasAnimation {
      Button {
        model.advanceAnimation()
      } label: {
        Image("play_button").resizable().scaledToFit().frame(width: 150)
      }
      .disabled(experiment.phase != .explaining)
    }
  }

  private var seedShelf: some View {
    ZStack {
      RoundedRectangle(cornerRadius: 20).foregroundColor(Color(hex: 0x147B0F))
      ScrollView(.horizontal, showsIndicators: false) {
        HStack(alignment: .top) {
          ForEach(experiment.inventory) { species in
            PlantCard(
              species: species, showsGenotypes: experiment.lesson.showsGenotypes,
              isDraggable: experiment.canSelectParents)
          }
          ForEach(0..<experiment.unknownCount, id: \.self) { _ in
            PlantCard(species: .unknown, showsGenotypes: experiment.lesson.showsGenotypes)
          }
        }
      }
    }
    .frame(height: 150)
  }

  private var experimentAnimation: some View {
    VStack(spacing: 20) {
      if experiment.animationStage.rawValue < Experiment.AnimationStage.gametes.rawValue {
        HStack(spacing: 100) {
          plot(first: true)
          plot(first: false)
        }
      } else if experiment.lesson.hasAnimation {
        HStack {
          GametesView(gametes: experiment.firstGametes)
          if experiment.animationStage == .gametes {
            Spacer().frame(width: 300).transition(.scale)
          } else if experiment.animationStage == .offspring {
            OffspringView(
              firstGametes: experiment.firstGametes,
              secondGametes: experiment.secondGametes)
          }
          GametesView(gametes: experiment.secondGametes)
        }
        .padding()
      }
    }
  }

  private func plot(first: Bool) -> some View {
    PlantPlot(
      selected: model.parentBinding(first: first), growthStage: model.growthStage,
      showsGenotypes: experiment.animationStage == .genotypes,
      acceptsDrops: experiment.canSelectParents,
      availableIDs: Set(experiment.inventory.map(\.id)))
  }

  private var tomatoRain: some View {
    ForEach(model.fallingTomatoes) { tomato in
      Image(tomato.imageName)
        .resizable()
        .scaledToFit()
        .position(x: tomato.x, y: UIScreen.main.bounds.height + 500)
        .frame(width: 50)
        .transition(.offset(x: 0, y: -(UIScreen.main.bounds.height + 600)))
    }
    .allowsHitTesting(false)
  }
}
