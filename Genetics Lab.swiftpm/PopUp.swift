import SwiftUI

extension View {
  func popup<Overlay: View>(
    isPresented: Binding<Bool>, @ViewBuilder content: () -> Overlay
  ) -> some View {
    allowsHitTesting(!isPresented.wrappedValue)
      .overlay(
        Group {
          if isPresented.wrappedValue { content() }
        })
  }
}
