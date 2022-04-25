//
//  SucceedView.swift
//  Gene Lab
//
//  Created by Han Chubo on 2022/4/18.
//

import SwiftUI

struct SucceedView: View {
    
    let plants: [PlantSpecies]
    let eachPlantsNumber: [Int]
    let plantSpeciesNumber: Int
    let isFreeCombination: Bool
    
    let newIDs: [Int]
    
    let rule = [GridItem(.adaptive(minimum: 100, maximum: 300))]
    
    let thisViewID: Int
    
    @Binding var showSucceedView: Bool
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .foregroundColor(Color.green)
            VStack {
                ZStack {
                    Image("button_image")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200)
                    Text("Harvest")
                        .font(.system(.largeTitle, design: .rounded))
                        .foregroundColor(Color.black)
                }
                
                    
                Divider()
                ScrollView(.vertical, showsIndicators: true) {
                    LazyVGrid(columns: rule, spacing: 20) {
                        
                        ForEach (0 ..< plants.count , id:\.self) {
                            index in
                            ZStack {
                                plantImage(plant: plants[index], showFactors: thisViewID == 0 ? false : true)
                                if newIDs.contains(plants[index].id) {
                                    Image("new")
                                        .resizable()
                                        .scaledToFit()
                                        .offset(x: 5, y: thisViewID == 0 ? -40 : -65)
                                        .frame(width: 60)
                                        .rotationEffect(Angle.init(degrees: 30))
                                        
                                }
                                // Text(plants[index].plantBasis.getAllGeneTypeString() + " x" + String(eachPlantsNumber[index]))
                            }
                        }
                    }
                }
                .frame(height: 450)
                // Text("Success Harvest! You have obtained 300 red tomato seeds and 100 yellow tomato seeds.")
                
                Spacer()
                if (thisViewID < 4) {
                    // NavigationLink("下一页", destination: InstructionView(id: thisViewID + 1))
                    NavigationLink(destination: InstructionView(id: thisViewID + 1), label: {
                        ZStack {
                            Image("common_button")
                                .resizable()
                                .scaledToFit()
                            Text("OK")
                                .font(.system(.title, design: .rounded))
                                .foregroundColor(Color.black)
                        }
                        .frame(width: 200)
                    })
                } else {
                    Button(action: {
                        withAnimation(.easeInOut) {
                            showSucceedView = false
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
                
                
            }
            .padding()
            .foregroundColor(Color.white)
        }
        .frame(width: 600, height: 650)
        .shadow(radius: 20)
    }
}

//struct SucceedView_Previews: PreviewProvider {
//    static var previews: some View {
//        SucceedView(plants: startPlants, eachPlantsNumber: [30, 50], plantSpeciesNumber: 2, isFreeCombination: true, showSucceedView: $showSucceedView)
//    }
//}
