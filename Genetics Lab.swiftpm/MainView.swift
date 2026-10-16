//
//  MainView.swift
//  Gene Lab
//
//  Created by Han Chubo on 2022/4/18.
//

import SwiftUI

@MainActor
struct MainView: View {
  var body: some View {
    NavigationView {
      InstructionView(lesson: .firstLesson)
    }
    .navigationViewStyle(.stack)
  }
}

@MainActor
struct MainView_Previews: PreviewProvider {
  static var previews: some View {
    MainView()
  }
}
