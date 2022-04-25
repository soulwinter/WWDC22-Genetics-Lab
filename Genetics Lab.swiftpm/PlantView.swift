//
//  PlantView.swift
//  Gene Lab
//
//  Created by Han Chubo on 2022/4/17.
//

import SwiftUI

// 在下面的边框栏显示的控件
@ViewBuilder
func plantImage(plant: PlantSpecies, showFactors: Bool = true) -> some View {
    if (plant.id != 99)
    {
        VStack(spacing: 0) {
            ZStack {
                Image("canva")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                plant.image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                
                // Text(plant.name)
            }
            if (showFactors) {
                ZStack {
                    Image("show_factors")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 50)
                    Text(plant.plantBasis.getAllGeneTypeString())
                        .font(.system(.body, design: .monospaced))
                        .foregroundColor(Color.black)
                }
            }
            
        }
        
        .onDrag {
            NSItemProvider(object: String(plant.id) as NSItemProviderWriting)
        }
    } else {
        VStack(spacing: 0) {
            ZStack {
                Image("canva")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                plant.image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                
                // Text(plant.name)
            }
            if (showFactors) {
                ZStack {
                    Image("show_factors")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 50)
                    Text("?")
                        .font(.system(.body, design: .monospaced))
                        .foregroundColor(Color.black)
                }
            }
            
        }
        
    }
    
    
    
    
}

// 在中间显示的
@ViewBuilder
func selectedPlantImage(id: String) -> some View {
    if id.isEmpty {
        
    } else {
        let plant = PlantSpecies(id: Int(id)!)
        plant.image
            .resizable()
            .scaledToFit()
    }
    
}


