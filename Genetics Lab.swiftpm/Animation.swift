//
//  Animation.swift
//  Gene Lab
//
//  Created by Han Chubo on 2022/4/18.
//

import SwiftUI

struct factorImage {
    var factors: [[Factor]] = []

    init(plant: PlantSpecies) {
        // (factors,_) = plant.plantBasis.getPlentyOfRandomFactors(num: 100)
        for _ in 1...3 {
            factors.append(plant.plantBasis.getPlantRandomFactors())
        }
      
    }
    
    init() {
        
    }
    func getFactors() -> [[Factor]]
    {
        return factors
    }
  
}
func factorImageToPlants(factor1: factorImage, factor2: factorImage) -> [PlantSpecies] {
    var plantS: [PlantSpecies] = []
    var tempSpecies: PlantSpecies
    var tempPlant: Plant
    for i in 0...factor1.factors.count - 1 {
        tempPlant = combineAsPlant(factors1: factor1.factors[i], factors2: factor2.factors[i])
        tempSpecies = PlantSpecies(gene: tempPlant)
        plantS.append(tempSpecies)
    }
    return plantS
}

@ViewBuilder
func drawFactors(factor1: factorImage, factor2: factorImage) -> some View {
    let plant = factorImageToPlants(factor1: factor1, factor2: factor2)
    VStack {
        ForEach (0 ..< factor1.factors.count, id:\.self) {
            index in
            ZStack {
                plant[index].image
                    .resizable()
                    .scaledToFit()
                Image("show_factors")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 30)
                    .offset(x: 30, y: 30)
                Text(plant[index].plantBasis.getAllGeneTypeString())
                    .font(.system(.body, design: .monospaced))
                    .foregroundColor(Color.black)
                    .offset(x: 30, y: 30)
                
            }
            
            .frame(width: 100, height: 100)
            
                            
        }
    }
    .transition(.opacity)
    
}

@ViewBuilder
func drawFactor(factor: factorImage) -> some View {
    VStack(spacing: 50) {
            ForEach (0 ..< factor.factors.count, id:\.self) {
                index in
                ZStack {
                    Image("factor")
                        .resizable()
                        .scaledToFit()
                    Text(factorsToString(factors: factor.factors[index]))
                        .font(.system(.headline, design: .monospaced))
                        .foregroundColor(Color.black)
                }
                .frame(width: 50, height: 50)
                
                        
            }
        }
       
        
}

@ViewBuilder
func drawPlantToFactors(plant: PlantSpecies) -> some View {
    ZStack {
//        RoundedRectangle(cornerRadius: 20)
//
//            .foregroundColor(Color(hex: 0xC4B1B1))
//            .overlay(
//                RoundedRectangle(cornerRadius: 35.0/2, style: .continuous)
//                    .stroke(Color(hex: 0x318D2D), lineWidth: 5)
//            )
        Image("factors")
            .resizable()
            .scaledToFit()
        Text(plant.plantBasis.getAllGeneTypeString())
            .font(.system(.largeTitle, design: .monospaced))
            .foregroundColor(Color.black)
        
    }
    .frame(width: 200, height: 200, alignment: .center)
    .transition(.opacity)
}

