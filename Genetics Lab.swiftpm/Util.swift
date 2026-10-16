import SwiftUI
import UniformTypeIdentifiers

extension Color {
  init(hex: Int, alpha: Double = 1) {
    self.init(
      .sRGB,
      red: Double((hex >> 16) & 0xff) / 255,
      green: Double((hex >> 8) & 0xff) / 255,
      blue: Double(hex & 0xff) / 255,
      opacity: alpha)
  }
}

struct PlantDropDelegate: DropDelegate {
  @Binding var selection: PlantSpecies?
  let availableIDs: Set<Int>
  let isEnabled: Bool

  func validateDrop(info: DropInfo) -> Bool {
    isEnabled && info.hasItemsConforming(to: [UTType.text.identifier])
  }

  func performDrop(info: DropInfo) -> Bool {
    guard validateDrop(info: info),
      let item = info.itemProviders(for: [UTType.text.identifier]).first
    else { return false }
    item.loadItem(forTypeIdentifier: UTType.text.identifier, options: nil) { value, error in
      guard error == nil else { return }
      let text: String?
      if let data = value as? Data {
        text = String(data: data, encoding: .utf8)
      } else {
        text = value as? String
      }
      guard let text = text, let id = Int(text), availableIDs.contains(id),
        let species = PlantCatalog.species(id: id)
      else { return }
      DispatchQueue.main.async { selection = species }
    }
    return true
  }
}
