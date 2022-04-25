//
//  PlantsData.swift
//  Gene Lab
//
//  Created by Han Chubo on 2022/4/17.
//

import SwiftUI


// 1 颜色 Aa
// 2 形状 Bb
// 3 易感病 Cc
// 培育成功后天上降下来🍅emoji
let factorA = Factor(char: "a", type: 1)
let factora = Factor(char: "a", type: 0)
let factorB = Factor(char: "b", type: 1)
let factorb = Factor(char: "b", type: 0)
let factorC = Factor(char: "c", type: 1)
let factorc = Factor(char: "c", type: 0)


struct PlantSpecies {
    
    var plantBasis = Plant()
    var id = 0;
    var name = ""
    var image: Image = Image("grass1")
    
    
    init(id: Int)
    {
        var geneType1 = GeneType()
        var geneType2 = GeneType()
        var geneType3 = GeneType()
        self.id = id
        switch self.id
        {
            // 1,2,3 用在第一关，即只有一个基因型
        case 1: //aa
            name = "Yellow 🍅"
            image = Image("yellow_round_healthy")
            geneType1 = combineFactor(factora, factora)
            plantBasis.geneType = [geneType1]
        case 2: //AA
            name = "Red 🍅"
            image = Image("red_round_healthy")
            geneType1 = combineFactor(factorA, factorA)
            plantBasis.geneType = [geneType1]
        case 3: //Aa
            name = "Red 🍅"
            image = Image("red_round_healthy")
            geneType1 = combineFactor(factorA, factora)
            plantBasis.geneType = [geneType1]
            
            // 4-12 有两个基因型
        case 4: //AABB
            name = "Red Round 🍅"
            image = Image("red_round_healthy")
            geneType1 = combineFactor(factorA, factorA)
            geneType2 = combineFactor(factorB, factorB)
            plantBasis.geneType = [geneType1, geneType2]
        case 5: //AaBB
            name = "Red Round 🍅"
            image = Image("red_round_healthy")
            geneType1 = combineFactor(factorA, factora)
            geneType2 = combineFactor(factorB, factorB)
            plantBasis.geneType = [geneType1, geneType2]
        case 6: //aaBB
            name = "Yellow Round 🍅"
            image = Image("yellow_round_healthy")
            geneType1 = combineFactor(factora, factora)
            geneType2 = combineFactor(factorB, factorB)
            plantBasis.geneType = [geneType1, geneType2]
        case 7: //AABb
            name = "Red Round 🍅"
            image = Image("red_round_healthy")
            geneType1 = combineFactor(factorA, factorA)
            geneType2 = combineFactor(factorB, factorb)
            plantBasis.geneType = [geneType1, geneType2]
        case 8: //AaBb
            name = "Red Round 🍅"
            image = Image("red_round_healthy")
            geneType1 = combineFactor(factorA, factora)
            geneType2 = combineFactor(factorB, factorb)
            plantBasis.geneType = [geneType1, geneType2]
        case 9: //aaBb
            name = "Yellow Round 🍅"
            image = Image("yellow_round_healthy")
            geneType1 = combineFactor(factora, factora)
            geneType2 = combineFactor(factorB, factorb)
            plantBasis.geneType = [geneType1, geneType2]
        case 10: //AAbb
            name = "Red Pear-Shaped 🍅"
            image = Image("red_pear-shaped_healthy")
            geneType1 = combineFactor(factorA, factorA)
            geneType2 = combineFactor(factorb, factorb)
            plantBasis.geneType = [geneType1, geneType2]
        case 11: //Aabb
            name = "Red Pear-Shaped 🍅"
            image = Image("red_pear-shaped_healthy")
            geneType1 = combineFactor(factorA, factora)
            geneType2 = combineFactor(factorb, factorb)
            plantBasis.geneType = [geneType1, geneType2]
        case 12: //aabb
            name = "Yellow Pear-Shaped 🍅"
            image = Image("yellow_pear-shaped_healthy")
            geneType1 = combineFactor(factora, factora)
            geneType2 = combineFactor(factorb, factorb)
            plantBasis.geneType = [geneType1, geneType2]
            
            
            
            
        case 13:
            name = "red round healthy 🍅"
            image = Image("red_round_healthy")
            geneType1 = combineFactor(factorA, factorA)
            geneType2 = combineFactor(factorB, factorB)
            geneType3 = combineFactor(factorC, factorC)
            plantBasis.geneType = [geneType1, geneType2, geneType3]
        case 14:
            name = "red round healthy 🍅"
            image = Image("red_round_healthy")
            geneType1 = combineFactor(factorA, factorA)
            geneType2 = combineFactor(factorB, factorB)
            geneType3 = combineFactor(factorC, factorc)
            plantBasis.geneType = [geneType1, geneType2, geneType3]
        case 15:
            name = "red round disease 🍅"
            image = Image("red_round_disease")
            geneType1 = combineFactor(factorA, factorA)
            geneType2 = combineFactor(factorB, factorB)
            geneType3 = combineFactor(factorc, factorc)
            plantBasis.geneType = [geneType1, geneType2, geneType3]
        case 16:
            name = "red round healthy 🍅"
            image = Image("red_round_healthy")
            geneType1 = combineFactor(factorA, factorA)
            geneType2 = combineFactor(factorB, factorb)
            geneType3 = combineFactor(factorC, factorC)
            plantBasis.geneType = [geneType1, geneType2, geneType3]
        case 17:
            name = "red round healthy 🍅"
            image = Image("red_round_healthy")
            geneType1 = combineFactor(factorA, factorA)
            geneType2 = combineFactor(factorB, factorb)
            geneType3 = combineFactor(factorC, factorc)
            plantBasis.geneType = [geneType1, geneType2, geneType3]
        case 18:
            name = "red round disease 🍅"
            image = Image("red_round_disease")
            geneType1 = combineFactor(factorA, factorA)
            geneType2 = combineFactor(factorB, factorb)
            geneType3 = combineFactor(factorc, factorc)
            plantBasis.geneType = [geneType1, geneType2, geneType3]
        case 19:
            name = "red pear-shaped healthy 🍅"
            image = Image("red_pear-shaped_healthy")
            geneType1 = combineFactor(factorA, factorA)
            geneType2 = combineFactor(factorb, factorb)
            geneType3 = combineFactor(factorC, factorC)
            plantBasis.geneType = [geneType1, geneType2, geneType3]
        case 20:
            name = "red pear-shaped healthy 🍅"
            image = Image("red_pear-shaped_healthy")
            geneType1 = combineFactor(factorA, factorA)
            geneType2 = combineFactor(factorb, factorb)
            geneType3 = combineFactor(factorC, factorc)
            plantBasis.geneType = [geneType1, geneType2, geneType3]
        case 21:
            name = "red pear-shaped disease 🍅"
            image = Image("red_pear-shaped_disease")
            geneType1 = combineFactor(factorA, factorA)
            geneType2 = combineFactor(factorb, factorb)
            geneType3 = combineFactor(factorc, factorc)
            plantBasis.geneType = [geneType1, geneType2, geneType3]
        case 22:
            name = "red round healthy 🍅"
            image = Image("red_round_healthy")
            geneType1 = combineFactor(factorA, factora)
            geneType2 = combineFactor(factorB, factorB)
            geneType3 = combineFactor(factorC, factorC)
            plantBasis.geneType = [geneType1, geneType2, geneType3]
        case 23:
            name = "red round healthy 🍅"
            image = Image("red_round_healthy")
            geneType1 = combineFactor(factorA, factora)
            geneType2 = combineFactor(factorB, factorB)
            geneType3 = combineFactor(factorC, factorc)
            plantBasis.geneType = [geneType1, geneType2, geneType3]
        case 24:
            name = "red round disease 🍅"
            image = Image("red_round_disease")
            geneType1 = combineFactor(factorA, factora)
            geneType2 = combineFactor(factorB, factorB)
            geneType3 = combineFactor(factorc, factorc)
            plantBasis.geneType = [geneType1, geneType2, geneType3]
        case 25:
            name = "red round healthy 🍅"
            image = Image("red_round_healthy")
            geneType1 = combineFactor(factorA, factora)
            geneType2 = combineFactor(factorB, factorb)
            geneType3 = combineFactor(factorC, factorC)
            plantBasis.geneType = [geneType1, geneType2, geneType3]
        case 26:
            name = "red round healthy 🍅"
            image = Image("red_round_healthy")
            geneType1 = combineFactor(factorA, factora)
            geneType2 = combineFactor(factorB, factorb)
            geneType3 = combineFactor(factorC, factorc)
            plantBasis.geneType = [geneType1, geneType2, geneType3]
        case 27:
            name = "red round disease 🍅"
            image = Image("red_round_disease")
            geneType1 = combineFactor(factorA, factora)
            geneType2 = combineFactor(factorB, factorb)
            geneType3 = combineFactor(factorc, factorc)
            plantBasis.geneType = [geneType1, geneType2, geneType3]
        case 28:
            name = "red pear-shaped healthy 🍅"
            image = Image("red_pear-shaped_healthy")
            geneType1 = combineFactor(factorA, factora)
            geneType2 = combineFactor(factorb, factorb)
            geneType3 = combineFactor(factorC, factorC)
            plantBasis.geneType = [geneType1, geneType2, geneType3]
        case 29:
            name = "red pear-shaped healthy 🍅"
            image = Image("red_pear-shaped_healthy")
            geneType1 = combineFactor(factorA, factora)
            geneType2 = combineFactor(factorb, factorb)
            geneType3 = combineFactor(factorC, factorc)
            plantBasis.geneType = [geneType1, geneType2, geneType3]
        case 30:
            name = "red pear-shaped disease 🍅"
            image = Image("red_pear-shaped_disease")
            geneType1 = combineFactor(factorA, factora)
            geneType2 = combineFactor(factorb, factorb)
            geneType3 = combineFactor(factorc, factorc)
            plantBasis.geneType = [geneType1, geneType2, geneType3]
        case 31:
            name = "yellow round healthy 🍅"
            image = Image("yellow_round_healthy")
            geneType1 = combineFactor(factora, factora)
            geneType2 = combineFactor(factorB, factorB)
            geneType3 = combineFactor(factorC, factorC)
            plantBasis.geneType = [geneType1, geneType2, geneType3]
        case 32:
            name = "yellow round healthy 🍅"
            image = Image("yellow_round_healthy")
            geneType1 = combineFactor(factora, factora)
            geneType2 = combineFactor(factorB, factorB)
            geneType3 = combineFactor(factorC, factorc)
            plantBasis.geneType = [geneType1, geneType2, geneType3]
        case 33:
            name = "yellow round disease 🍅"
            image = Image("yellow_round_disease")
            geneType1 = combineFactor(factora, factora)
            geneType2 = combineFactor(factorB, factorB)
            geneType3 = combineFactor(factorc, factorc)
            plantBasis.geneType = [geneType1, geneType2, geneType3]
        case 34:
            name = "yellow round healthy 🍅"
            image = Image("yellow_round_healthy")
            geneType1 = combineFactor(factora, factora)
            geneType2 = combineFactor(factorB, factorb)
            geneType3 = combineFactor(factorC, factorC)
            plantBasis.geneType = [geneType1, geneType2, geneType3]
        case 35:
            name = "yellow round healthy 🍅"
            image = Image("yellow_round_healthy")
            geneType1 = combineFactor(factora, factora)
            geneType2 = combineFactor(factorB, factorb)
            geneType3 = combineFactor(factorC, factorc)
            plantBasis.geneType = [geneType1, geneType2, geneType3]
        case 36:
            name = "yellow round disease 🍅"
            image = Image("yellow_round_disease")
            geneType1 = combineFactor(factora, factora)
            geneType2 = combineFactor(factorB, factorb)
            geneType3 = combineFactor(factorc, factorc)
            plantBasis.geneType = [geneType1, geneType2, geneType3]
        case 37:
            name = "yellow pear-shaped healthy 🍅"
            image = Image("yellow_pear-shaped_healthy")
            geneType1 = combineFactor(factora, factora)
            geneType2 = combineFactor(factorb, factorb)
            geneType3 = combineFactor(factorC, factorC)
            plantBasis.geneType = [geneType1, geneType2, geneType3]
        case 38:
            name = "yellow pear-shaped healthy 🍅"
            image = Image("yellow_pear-shaped_healthy")
            geneType1 = combineFactor(factora, factora)
            geneType2 = combineFactor(factorb, factorb)
            geneType3 = combineFactor(factorC, factorc)
            plantBasis.geneType = [geneType1, geneType2, geneType3]
        case 39:
            name = "yellow pear-shaped disease 🍅"
            image = Image("yellow_pear-shaped_disease")
            geneType1 = combineFactor(factora, factora)
            geneType2 = combineFactor(factorb, factorb)
            geneType3 = combineFactor(factorc, factorc)
            plantBasis.geneType = [geneType1, geneType2, geneType3]
        case 99:
            name = "unknown"
            image = Image("questionmark")
        default:
            name = "error"
            
        }
    }
    
    init(gene: Plant)
    {
        self.plantBasis = gene
        switch gene.getAllGeneTypeString() {
        case "aa":
            id = 1
            name = "Yellow 🍅"
            image = Image("yellow_pear-shaped_healthy")
        case "AA":
            id = 2
            name = "Red 🍅"
            image = Image("red_round_healthy")
        case "Aa":
            id = 3
            name = "Red 🍅"
            image = Image("red_round_healthy")
        case "AABB":
            id = 4
            name = "Red Round 🍅"
            image = Image("red_round_healthy")
        case "AaBB":
            id = 5
            name = "Red Round 🍅"
            image = Image("red_round_healthy")
        case "aaBB":
            id = 6
            name = "Yellow Round 🍅"
            image = Image("yellow_round_healthy")
        case "AABb":
            id = 7
            name = "Red Round 🍅"
            image = Image("red_round_healthy")
        case "AaBb":
            id = 8
            name = "Red Round 🍅"
            image = Image("red_round_healthy")
        case "aaBb":
            id = 9
            name = "Yellow Round 🍅"
            image = Image("yellow_round_healthy")
        case "AAbb":
            id = 10
            name = "Red Pear-Shaped 🍅"
            image = Image("red_pear-shaped_healthy")
        case "Aabb":
            id = 11
            name = "Red Pear-Shaped 🍅"
            image = Image("red_pear-shaped_healthy")
        case "aabb":
            id = 12
            name = "Yellow Pear-Shaped 🍅"
            image = Image("yellow_pear-shaped_healthy")
        case "AABBCC":
            id = 13
            name = "red round healthy 🍅"
            image = Image("red_round_healthy")
        case "AABBCc":
            id = 14
            name = "red round healthy 🍅"
            image = Image("red_round_healthy")
        case "AABBcc":
            id = 15
            name = "red round disease 🍅"
            image = Image("red_round_disease")
        case "AABbCC":
            id = 16
            name = "red round healthy 🍅"
            image = Image("red_round_healthy")
        case "AABbCc":
            id = 17
            name = "red round healthy 🍅"
            image = Image("red_round_healthy")
        case "AABbcc":
            id = 18
            name = "red round disease 🍅"
            image = Image("red_round_disease")
        case "AAbbCC":
            id = 19
            name = "red pear-shaped healthy 🍅"
            image = Image("red_pear-shaped_healthy")
        case "AAbbCc":
            id = 20
            name = "red pear-shaped healthy 🍅"
            image = Image("red_pear-shaped_healthy")
        case "AAbbcc":
            id = 21
            name = "red pear-shaped disease 🍅"
            image = Image("red_pear-shaped_disease")
        case "AaBBCC":
            id = 22
            name = "red round healthy 🍅"
            image = Image("red_round_healthy")
        case "AaBBCc":
            id = 23
            name = "red round healthy 🍅"
            image = Image("red_round_healthy")
        case "AaBBcc":
            id = 24
            name = "red round disease 🍅"
            image = Image("red_round_disease")
        case "AaBbCC":
            id = 25
            name = "red round healthy 🍅"
            image = Image("red_round_healthy")
        case "AaBbCc":
            id = 26
            name = "red round healthy 🍅"
            image = Image("red_round_healthy")
        case "AaBbcc":
            id = 27
            name = "red round disease 🍅"
            image = Image("red_round_disease")
        case "AabbCC":
            id = 28
            name = "red pear-shaped healthy 🍅"
            image = Image("red_pear-shaped_healthy")
        case "AabbCc":
            id = 29
            name = "red pear-shaped healthy 🍅"
            image = Image("red_pear-shaped_healthy")
        case "Aabbcc":
            id = 30
            name = "red pear-shaped disease 🍅"
            image = Image("red_pear-shaped_disease")
        case "aaBBCC":
            id = 31
            name = "yellow round healthy 🍅"
            image = Image("yellow_round_healthy")
        case "aaBBCc":
            id = 32
            name = "yellow round healthy 🍅"
            image = Image("yellow_round_healthy")
        case "aaBBcc":
            id = 33
            name = "yellow round disease 🍅"
            image = Image("yellow_round_disease")
        case "aaBbCC":
            id = 34
            name = "yellow round healthy 🍅"
            image = Image("yellow_round_healthy")
        case "aaBbCc":
            id = 35
            name = "yellow round healthy 🍅"
            image = Image("yellow_round_healthy")
        case "aaBbcc":
            id = 36
            name = "yellow round disease 🍅"
            image = Image("yellow_round_disease")
        case "aabbCC":
            id = 37
            name = "yellow pear-shaped healthy 🍅"
            image = Image("yellow_pear-shaped_healthy")
        case "aabbCc":
            id = 38
            name = "yellow pear-shaped healthy 🍅"
            image = Image("yellow_pear-shaped_healthy")
        case "aabbcc":
            id = 39
            name = "yellow pear-shaped disease 🍅"
            image = Image("yellow_pear-shaped_disease")
        case "?":
            id = 99
            name = "unknown"
            image = Image("questionmark")
        default:
            name = "error"
            
        }
    }
}

extension PlantSpecies: Equatable, Hashable {
    
    static func ==(lhs: PlantSpecies, rhs: PlantSpecies) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        var hashValue: Int {
            var hasher = Hasher()
            self.hash(into: &hasher)
            return hasher.finalize()
        }
    }
}


func haveNewSpecies(plant: PlantSpecies, haveGot: [PlantSpecies]) -> Bool {
    for haveGet in haveGot {
        if haveGet.id == plant.id {
            return false
        }
    }
    return true
}

// 获得新植物的 id 序号数组
func getNewSpeciesNumber(newPlants: [PlantSpecies], haveGot: [PlantSpecies]) -> [Int] {
    var new: [Int] = []
    for newPlant in newPlants {
        if haveNewSpecies(plant: newPlant, haveGot: haveGot) {
            new.append(newPlant.id)
        }
    }
    return new
}

func getNewPlantSpecies(plant1: PlantSpecies, plant2: PlantSpecies) -> ([PlantSpecies], [Int]) {
    var plants: [Plant] = []
    var plantSpecies: [PlantSpecies] = []
    let number = Int.random(in: 40...150)
    for _ in 1...number  {
        plants.append(combineAsPlant(factors1: plant1.plantBasis.getPlantRandomFactors(),
                                     factors2: plant2.plantBasis.getPlantRandomFactors()))
        plantSpecies.append(PlantSpecies(gene: plants.last!))
    }
    
    let k = plantSpecies.reduce(into: [:]) { $0[$1, default: 0] += 1}
    let keys = k.map{$0.key}
    let values = k.map{$0.value}
    return (keys, values)
    
}

func getPlantSpeciesFromStringID(id: String) -> PlantSpecies {
    // TODO: 条件判断
    return PlantSpecies(id: Int(id)!)
}

let titles = ["First Lesson", "In Depth", "Combination Of Multiple Traits", "What Happened?", "Cultivate Your Variety"]
let instructionContents = ["""
Welcome to the Genetics Lab! Here you will learn how the world's diverse organisms pass on their traits to their offspring and create a wide variety of mutations in the process.
We will explore one of the most common plants, the tomato🍅, as an example. See those question marks? They represent tomato varieties we haven't discovered yet, and at the end, we'll unlock them all!
At the very beginning, let's examine the color of the tomatoes. Tomatoes come in two color varieties, red and yellow. Have you ever thought about pollinating and crossing these two varieties? Give it a try. **Drag and drop the two tomato seeds onto both two tilled fields and tap Cross**.
""",
"""
The offspring of red and yellow tomatoes are actually only red tomatoes?! **Let's try again**, and this time we'll dive into their genetic principles together.
You may have noticed some differences. Two letters are now displayed below each seed! You'll know what they are right away!
""",
"""
Did you know that there is actually another type of tomato that looks like a pear? Suppose we call the genotype of a round tomato **[BB]**, **[Bb]** and the genotype of a pear-shaped tomato **[bb]** (yes, round is the dominant genotype)
Now, what will happen if **we cross a red round tomato with genotype [AaBb] with a yellow pear-shaped tomato with genotype [aabb]?** Let's try it!
""",
"""
You got completely different tomato varieties from their parents by the experiment you just did! Bravo!
Now, let's look at how this was done. Do it again.
""",
"""
You've learned the most basic and important principles of genetics! Now it's time to create your own variety of tomato!
We have now discovered a gene in tomatoes that affects its susceptibility to insect pests, and we call the genotypes that have pest resistance **[CC]**, **[Cc]** and the ones that are susceptible to pests **[cc]**.
Now we have three plants **[AAbbcc]**, **[aaBBcc]**, **[aabbCC]**. Can you get all the unknown varieties of tomatoes through them?
You can do this through multiple crosses, so give it a try! Note that since tomatoes can only produce 40-150 fruits in one cross, you may not get all possible genotypes at a time.
"""
                           

]

let animationContects = [["""
As shown below, in general, the trait of an organism is represented by a pair of letters called *hereditary factor*.
In our example, the color of a tomato can be represented by **[AA], [Aa] or [aa]**. **[AA] and [Aa]** both represent red, while **[aa]** represents yellow.
The variety that account for a large proportion are called *dominant trait*, and the other is called  *recessive trait*. In this case, red is the dominant trait. And this pair of letters we call it *genotype*.
""",
"""
It's plant pollen production time! The three pairs of tiny yellow circles are the pollen produced by the female plant and the anthers produced by the male plant that we found at random. Each pollen or anther also contains a letter (hereditary factor), and this hereditary factor is randomly drawn from the genotype of the original plant.
""",
"""
After bees and other insects pollinate these flowers, the pollen and anthers merge to become seeds. Their respective hereditary factors thus converge to become the genotype of the plant that the seeds will become! So all the seeds just now will become red tomatoes of type **[Aa]**!
""",
"""
And as just said, **[Aa]** stands for red tomato. So, the offspring of **[AA]** tomatoes and **[aa]** tomatoes are all **[Aa]** red tomatoes!
"""
],
["Again, let's show the genotypes of the plants on the screen. What kind of pollen and anthers do you think they will produce?",
"""
We found three more random pairs of pollen and anthers.
Did you notice the change? The red tomato **[AaBb]** plant produced pollen by first selecting one at random from **[Aa]** and then one at random from **[Bb]**. Thus, it may produce four gametes **[AB]**, **[Ab]**, **[aB]**, **[ab]**.
Next, It will then combine with **[ab]** of the **[aabb]** yellow plant (yellow plants can only produce this one anther!).
""",
"""
We found three more random pairs of pollen and anthers.
Did you notice the change? The red tomato **[AaBb]** plant produced pollen by first selecting one at random from **[Aa]** and then one at random from **[Bb]**. Thus, it may produce four *gametes* **[AB]**, **[Ab]**, **[aB]**, **[ab]**.
Next, It will then combine with **[ab]** of the **[aabb]** yellow plant (yellow plants can only produce this one anther!).
""",
"""
Genetics is just so amazing! Through hybridization, we can obtain a wide variety of plant types. In the next section, you'll be able to try to create your own!
"""]]
let initPlants: [[PlantSpecies]] = [
    [PlantSpecies(id: 2), PlantSpecies(id: 1)],
    [PlantSpecies(id: 2), PlantSpecies(id: 1)],
    [PlantSpecies(id: 8), PlantSpecies(id: 12)],
    [PlantSpecies(id: 8), PlantSpecies(id: 12)],
    [PlantSpecies(id: 21), PlantSpecies(id: 33), PlantSpecies(id: 37)]]





