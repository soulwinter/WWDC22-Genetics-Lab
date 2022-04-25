//
//  InstructionView.swift
//  Gene Lab
//
//  Created by Han Chubo on 2022/4/17.
//

import SwiftUI

struct InstructionView: View {
    
    @State var title: String
    @State var instructionContent: String
    @State var viewID: Int
    @State var plants: [PlantSpecies]
    
    var factorAnimationOn: Bool = false
    var isFreeCombination: Bool = true
    @State var unknownNumber = 26 - 2
    
    init(id: Int) {
        viewID = id
        title = titles[id]
        instructionContent = instructionContents[id]
        plants = initPlants[id]
        switch id {
        case 0:
            factorAnimationOn = false
            isFreeCombination = false
        case 1:
            factorAnimationOn = true
            isFreeCombination = false
        case 2:
            factorAnimationOn = false
            isFreeCombination = false
        case 3:
            factorAnimationOn = true
            isFreeCombination = false
        case 4:
            factorAnimationOn = false
            isFreeCombination = true
        default:
            factorAnimationOn = false
            isFreeCombination = true
        }
        
        
        
    }
    
    
    
    
    @State var textHeight: Double = 200
    
    @State var animationStage: Int = 0
    
    
    @State var getID1 = ""
    @State var getID2 = ""
    @State var factorImage1 = factorImage()
    @State var factorImage2 = factorImage()
    
    @State var oldPlants: [PlantSpecies] = []
    @State var newPlants: [PlantSpecies] = []
    @State var newPlantsNumber: [Int] = []
    
    @State var showSucceedView = false
    @State var showFailView: Bool = false
    @State var failID = 0
    @State var finishTheApp = false
    
    @State var emojiAppear = [Bool](repeating: false, count: 80)
    @State var emojiWidth = [CGFloat](repeating: 0, count: 80)
    
    
    @State var factorAnimationStart = false
    @State var plantToFactors = false
    @State var plantCombined = false
    @State var plantCombineToNew = false
    
    @State var growStage = 1
    let growImages = [Image("grow1"), Image("grow2"), Image("grow3"), Image("grow4")]
    
    @State var buttonUsable = true
    
    @State var fallTomatoes: [Int] = []
    
    
    
    
    
    
    var body: some View {
        ZStack {
            
            Color(hex: 0x666633).ignoresSafeArea()
            
            
            VStack() {
                ZStack() {
                    Rectangle()
                        .foregroundColor(Color(hex: 0x147B0F))
                    
                    VStack(alignment: .leading, spacing: 6) {
                        
                        Text(title)
                            .font(.system(size: 50, weight: .heavy, design: .rounded))
                            .foregroundColor(.white)
                        Text(.init(instructionContent))
                            .font(.body)
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(GeometryReader { fullGeometry in
                        
                        // And compare the two
                        Color.clear.onAppear {
                            self.textHeight = fullGeometry.size.height
                        }
                    })
                    
                }
                .frame(height: self.textHeight + 60)
                .ignoresSafeArea()
                
                Spacer()
            }
            
            
            VStack {
                
                Spacer()
                
                // MARK: 底部按钮
                if self.buttonUsable {
                    
                    // 重制按钮
                    HStack(spacing: 30) {
                        Button(action: {
                            getID1 = ""
                            getID2 = ""
                        }, label: {
                            ZStack {
                                Image("reset_button")
                                    .resizable()
                                    .scaledToFit()
                                Text("Reset")
                                    .font(.system(.largeTitle, design: .rounded))
                                    .foregroundColor(Color.black)
                                
                            }
                            .frame(width: 200)
                            
                        })
                        .disabled(!buttonUsable)
                        
                        
                        
                        
                        Button(action: {
                            if getID1 != "" && getID2 != "" {
                                
                                if (viewID != 4 && getID1 == getID2)
                                {
                                    withAnimation(.easeInOut) {
                                        showFailView = true
                                        failID = 0
                                        getID1 = ""
                                        getID2 = ""
                                    }
                                    
                                }
                                else {
                                    
                                    // 掉落番茄
                                    for e in 0 ..< self.emojiAppear.count {
                                        if (self.emojiAppear[e])
                                        {
                                            self.emojiAppear[e].toggle()
                                        }
                                    }
                                    
                                    
                                    // 逻辑处理
                                    (self.newPlants, self.newPlantsNumber) = getNewPlantSpecies(plant1: getPlantSpeciesFromStringID(id: getID1), plant2: getPlantSpeciesFromStringID(id: getID2))
                                    for newPlant in newPlants {
                                        fallTomatoes.append(newPlant.id)
                                    }
                                    factorImage1 = factorImage(plant: PlantSpecies(id: Int(getID1)!))
                                    factorImage2 = factorImage(plant: PlantSpecies(id: Int(getID2)!))
                                    
                                    // 将 oldPlant 传给 SucceedView
                                    self.oldPlants = self.plants
                                    
                                    // MARK: 植物生长
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                        withAnimation(.easeInOut) {
                                            self.growStage += 1
                                        }
                                    }
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                                        withAnimation(.easeInOut) {
                                            self.growStage += 1
                                        }
                                    }
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                        withAnimation(.easeInOut) {
                                            self.growStage += 1
                                        }
                                    }
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) {
                                        if self.factorAnimationOn  {
                                            self.buttonUsable = false
                                            self.title = ""
                                            self.instructionContent = "Tap the play button to see how the new seeds are created!"
                                        } else {
                                            // MARK: 自由组合
                                            if (self.isFreeCombination) {
                                                for newPlant in newPlants {
                                                    
                                                    if (haveNewSpecies(plant: newPlant, haveGot: plants)) {
                                                        // 这里写获得了新物种
                                                        plants.append(newPlant)
                                                        unknownNumber -= 1
                                                        
                                                        
                                                    }
                                                }
                                                if (unknownNumber == 0 && !finishTheApp) {
                                                    failID = 2
                                                    showFailView = true
                                                    finishTheApp = true
                                                }
                                                withAnimation(.easeInOut) {
                                                    self.showSucceedView = true
                                                    
                                                }
                                                self.growStage = 1
                                                getID1 = ""
                                                getID2 = ""
                                                
                                                
                                            }
                                            
                                            for e in 0 ..< self.emojiAppear.count {
                                                withAnimation(.easeIn(duration: Double.random(in: 3...5))) {
                                                    self.emojiWidth[e] = CGFloat.random(in: -500 ... UIScreen.main.bounds.width + 500)
                                                    self.emojiAppear[e] = true
                                                }
                                            }
                                            
                                            if (!self.isFreeCombination) {
                                                withAnimation(.easeInOut) {
                                                    self.showSucceedView = true
                                                    self.buttonUsable = false
                                                }
                                            }
                                            
                                        }
                                    }
                                    
                                    
                                    
                                    
                                    
                                    // MARK: 动画
                                    
                                } }
                            else {
                                withAnimation(.easeInOut) {
                                    self.showFailView = true
                                    failID = 1
                                }
                            }
                            
                        }, label: {
                            ZStack {
                                Image("combine_button")
                                    .resizable()
                                    .scaledToFit()
                                Text("Cross")
                                    .font(.system(.largeTitle, design: .rounded))
                                    .foregroundColor(Color.black)
                            }
                            .frame(width: 200)
                        })
                        .disabled(!buttonUsable)
                    }
                    
                    .transition(.scale)
                    
                }
                
                else if self.factorAnimationOn {
                    Button(action: {
                        
                        
                        
                        animationStage = animationStage + 1
                        
                        switch animationStage {
                        case 1:
                            self.title = ""
                            self.instructionContent = animationContects[self.viewID == 1 ? 0 : (self.viewID == 3 ? 1 : 0)][1-1]
                            withAnimation(.easeInOut(duration: 1)) {
                                self.plantToFactors.toggle()
                            }
                        case 2:
                            self.instructionContent = animationContects[self.viewID == 1 ? 0 : (self.viewID == 3 ? 1 : 0)][2-1]
                            withAnimation(.easeInOut(duration: 1)) {
                                self.factorAnimationStart.toggle()
                            }
                        case 3:
                            self.instructionContent = animationContects[self.viewID == 1 ? 0 : (self.viewID == 3 ? 1 : 0)][3-1]
                            withAnimation(.easeInOut(duration: 2)) {
                                self.plantCombined = true
                            }
                        case 4:
                            self.instructionContent = animationContects[self.viewID == 1 ? 0 : (self.viewID == 3 ? 1 : 0)][5-2]
                            withAnimation(.easeInOut(duration: 0.5)) {
                                self.plantCombineToNew = true
                            }
                        case 5:
                            
                            withAnimation(.easeInOut(duration: 1)) {
                                for e in 0 ..< self.emojiAppear.count {
                                    withAnimation(.easeIn(duration: Double.random(in: 3...5))) {
                                        self.emojiWidth[e] = CGFloat.random(in: -500 ... UIScreen.main.bounds.width + 500)
                                        self.emojiAppear[e] = true
                                    }
                                }
                                self.showSucceedView = true
                                
                            }
                        default:
                            print("error")
                        }
                    }, label: {
                        ZStack {
                            Image("play_button")
                                .resizable()
                                .scaledToFit()
                        }
                        .frame(width: 150)
                    })
                }
                
                
                // MARK: 底部植物栏
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(Color(hex: 0x147B0F))
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(alignment: .top)
                        {
                            // MARK: 根据关卡改动
                            ForEach (0 ..< plants.count + unknownNumber, id:\.self) {
                                index in
                                VStack {
                                    if index < plants.count
                                    {
                                        plantImage(plant: plants[index], showFactors: viewID == 0 ? false : true)
                                    } else {
                                        // 画出未知图像
                                        
                                        plantImage(plant: PlantSpecies(id: 99), showFactors: viewID == 0 ? false : true)
                                    }
                                    
                                }
                            }
                        }
                        
                    }
                }
                .frame( height: 150)
                
            }
            .padding()
            
            
            
            VStack(spacing: 20) {
                if !self.factorAnimationStart {
                    HStack(spacing: 100) {
                        ZStack {
                            
                            
                            // MARK: 画植物 1
                            Image("dirt")
                                .resizable()
                                .scaledToFit()
                                .onDrop(of: ["public.text"], delegate: PlantDropDelegate(receiveID: $getID1))
                            if (self.plantToFactors) {
                                drawPlantToFactors(plant: getPlantSpeciesFromStringID(id: getID1))
                            } else {
                                if (getID1 != "")
                                {
                                    Image("grow" + String(self.growStage))
                                        .resizable()
                                        .scaledToFit()
                                        .offset(y: -20)
                                        .transition(.opacity)
                                    
                                }
                            }
                            
                            
                        }
                        .frame(width: 250, height: 250, alignment: .center)
                        
                        
                        ZStack {
                            
                            // MARK: 画植物 2
                            
                            Image("dirt")
                                .resizable()
                                .scaledToFit()
                                .onDrop(of: ["public.text"], delegate: PlantDropDelegate(receiveID: $getID2))
                            if (self.plantToFactors) {
                                drawPlantToFactors(plant: getPlantSpeciesFromStringID(id: getID2))
                            } else {
                                if (getID2 != "")
                                {
                                    Image("grow" + String(self.growStage))
                                        .resizable()
                                        .scaledToFit()
                                        .offset(y: -20)
                                        .transition(.opacity)
                                    
                                }
                            }
                            
                            
                        }
                        .frame(width: 250, height: 250, alignment: .center)
                        
                    }
                }
                
                
                // MARK: 绘制 Factor
                if self.factorAnimationOn && self.factorAnimationStart {
                    
                    HStack() {
                        drawFactor(factor: factorImage1)
                        
                        
                        if (self.plantCombined) {
                            if (self.plantCombineToNew)
                            {
                                drawFactors(factor1:  factorImage1, factor2:  factorImage2)
                            }
                            
                        } else {
                            Spacer()
                                .frame(width: 300)
                                .transition(.scale)
                        }
                        
                        drawFactor(factor:  factorImage2)
                        
                        
                    }
                    .padding()
                    
                }
                
            }
            
            
            
            
            
            
            ForEach (0 ..< self.emojiAppear.count, id:\.self) {
                index in
                if self.emojiAppear[index] {
                    PlantSpecies(id: fallTomatoes[Int.random(in: 0...fallTomatoes.count - 1)]).image
                        .resizable()
                        .scaledToFit()
                        .position(x: self.emojiWidth[index], y: UIScreen.main.bounds.height + 500)
                        .frame(width: 50)
                        .transition(.offset(x: 0, y: -(UIScreen.main.bounds.height + 600)))
                }
                
            }
            
        }
        .popup(isPresented: $showSucceedView) {
            SucceedView(plants: self.newPlants, eachPlantsNumber: self.newPlantsNumber, plantSpeciesNumber: self.newPlants.count, isFreeCombination: isFreeCombination, newIDs: getNewSpeciesNumber(newPlants: self.newPlants, haveGot: self.oldPlants), thisViewID: viewID, showSucceedView: $showSucceedView)
                .transition(.scale)
        }
        .popup(isPresented: $showFailView) {
            FailView(showFailView: $showFailView, failID: $failID)
                .transition(.scale)
        }
        
        .navigationBarTitle("")
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        
    }
}


//
//struct InstructionView_Previews: PreviewProvider {
//    static var previews: some View {
//        InstructionView(title: "First Lesson ", instructionContent: "Welcome to the Genetic Genetics Lab. Are you curious about how the various animals and plants of the world inherit their characteristics? Here you will explore more by conducting your own plant hybrid experiments (This is a text sample, not the final result.)", factorAnimationOn: false, plants: [
//            PlantSpecies(id: 1),
//            PlantSpecies(id: 2),
//            PlantSpecies(id: 3)
//        ])
//    }
//}
