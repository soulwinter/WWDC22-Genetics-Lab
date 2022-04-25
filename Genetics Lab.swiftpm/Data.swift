//
//  Data.swift
//  GeneDataLab
//
//  Created by Han Chubo on 2022/4/15.
//

import Foundation

struct Factor {
    var type: Int = 0
    // 遗传因子，type 1 代表大写显性，type 0 代表小写隐性
    var char: String = ""
    // char 一律为小写
    
    var actucalChar: String {
        get {
            if (!char.isEmpty)
            {
                return type == 1 ? char.uppercased() : char.lowercased()
            } else {
                return ""
            }
        }
    }
    
    init(char: String)
    {
        self.char = char
    }
    
    init(char: String, type: Int)
    {
        self.char = char
        self.type = type
    }
    
}


struct GeneType {
    var type: Int = 0
    // 基因型，type 1: AA, type 2: Aa, type 3: aa
    var char: String = ""
    var str: String = ""
    
    
    // GeneType -> Both Factor
    func divideGeneType() -> (Factor, Factor) {
        var factor1 = Factor(char: char)
        var factor2 = Factor(char: char)
        if (type == 1)
        {
            factor1.type = 1
            factor2.type = 1
        }
        if (type == 2)
        {
            factor1.type = 1
            factor2.type = 0
        }
        if (type == 3)
        {
            factor1.type = 0
            factor2.type = 0
        }
        return (factor1, factor2)
    }
    
    // GeneType -> Random Factor
    func getFactorRandomly() -> Factor {
        var factor = Factor(char: char)
        
        if (type == 1)
        {
            factor.type = 1
        }
        if (type == 2)
        {
            factor.type = Int.random(in: 0...1)
        }
        if (type == 3)
        {
            factor.type = 0
        }
        return factor
    }
    
}

// Both Factor -> GeneType
func combineFactor(_ first: Factor, _ second: Factor) -> GeneType {
    var newGene: GeneType = GeneType()
    
    // 先假设两个基因一定是同一种基因
    newGene.char = first.char
        
    // 如果两个都是隐性，则新基因型也是隐性
    if (first.type == 0 && second.type == 0) {
        newGene.type = 3
        
        newGene.str = first.char + second.char
    }
    // 如果两个都是显性，则新基因型也是显性
    if (first.type == 1 && second.type == 1) {
        newGene.type = 1
        newGene.str = first.char.uppercased() + second.char.uppercased()
    }
    
    // 一显性，一隐性
    if (first.type == 1 && second.type == 0 ||
        first.type == 0 && second.type == 1) {
        newGene.type = 2
        newGene.str = first.char.uppercased() + second.char.lowercased()
    }
        
    return newGene
}



// 植物
struct Plant {
    var geneNumber: Int = 0
    var geneType: [GeneType] = []
    var description: String = ""
    func getAllGeneTypeString() -> String {
        var geneTypeString = ""
        for eachGeneType in geneType {
            geneTypeString += eachGeneType.str
        }
        return geneTypeString
    }
    
    // 分解 Plant -> Random Factors
    func getPlantRandomFactors() -> [Factor]
    {
        var factors: [Factor] = []
        for eachGeneType in geneType
        {
            factors.append(eachGeneType.getFactorRandomly())
        }
        
        return factors
    }

    // 随机获得 num 个数量的种子配子，返回元组（所有配子型数组，对应数组型的个数数组）
    func getPlentyOfRandomFactors(num: Int) -> ([[Factor]], [Int])
    {
        var allFactors = [[Factor]]()
        for _ in 1 ... num {
            allFactors.append(getPlantRandomFactors())
        }
        let k = allFactors.reduce(into: [:]) { $0[$1, default: 0] += 1 }
        let keys = k.map{$0.key}
        let values = k.map{$0.value}
        return (keys, values)
        
    }
    
    
    
    init(geneType: [GeneType]) {
        self.geneType = geneType
    }
    init() {
        geneType = []
    }
    
    
}




// Two Factors -> Plant
func combineAsPlant(factors1: [Factor], factors2: [Factor]) -> Plant {
    var newPlant = Plant()
    // todo: 异常处理
    
    for i in 0..<factors1.count {
        newPlant.geneType.append(combineFactor(factors1[i], factors2[i]))
    }
    return newPlant
}

// Factors -> String
func factorsToString(factors: [Factor]) -> String {
    var str: String = ""
    for i in factors {
        str += i.actucalChar
    }
    return str
}


extension Factor: Hashable, Codable {}
extension GeneType: Hashable, Codable {}
extension Plant: Hashable, Codable {}

