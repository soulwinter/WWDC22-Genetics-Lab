//
//  FailView.swift
//  Gene Lab
//
//  Created by Han Chubo on 2022/4/19.
//

import SwiftUI

struct FailView: View {
    @Binding var showFailView: Bool
    @Binding var failID: Int
    
    var failText = ["Please follow the instructions for sowing the correct variety of tomatoes! In the final chapter you will be able to combine freely!", "Please plant the tomato seeds on both 2 lands!", "You've managed to collect all the varieties of tomatoes! You have learned the most important principle about genetics!"]
    
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .foregroundColor(Color(hex: failID == 2 ? 0xF19203 : 0xFF8888))
            VStack {
                ZStack {
                    Image("button_image")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200)
                    Text(failID == 2 ? "Great!" :"Oops")
                        .font(.system(.largeTitle, design: .rounded))
                        .foregroundColor(Color.black)
                }
                
                
                Divider()
                Spacer()
                Text(failText[self.failID])
                    .padding()
                    .foregroundColor(Color.white)
                    .font(.system(.title2, design: .rounded))
                Spacer()
        
                
                Button(action: {
                    withAnimation(.easeInOut) {
                        showFailView = false
                    }
                    
                }) {
                    ZStack {
                        Image("common_button")
                            .resizable()
                            .scaledToFit()
                        Text("OK")
                            .font(.system(.title, design: .rounded))
                            .foregroundColor(Color.black)
                    }
                    .frame(width: 200)
                    
                }
                
                
                
            }
            .padding()
            .foregroundColor(Color.white)
        }
        .frame(width: 600, height: 350)
        .shadow(radius: 20)
    }
}

//struct FailView_Previews: PreviewProvider {
//    static var previews: some View {
//        FailView(showFailView: true)
//    }
//}
