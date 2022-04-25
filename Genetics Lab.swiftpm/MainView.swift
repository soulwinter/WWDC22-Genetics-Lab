//
//  MainView.swift
//  Gene Lab
//
//  Created by Han Chubo on 2022/4/18.
//

import SwiftUI


struct MainView: View {
    var body: some View {
        NavigationView {
            InstructionView(id: 0)
        }
        .navigationViewStyle(.stack)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
