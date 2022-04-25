//
//  File.swift
//  Gene Lab
//
//  Created by Han Chubo on 2022/4/17.
//

import SwiftUI

extension Color {
    init(hex: Int, alpha: Double = 1) {
        let components = (
            R: Double((hex >> 16) & 0xff) / 255,
            G: Double((hex >> 08) & 0xff) / 255,
            B: Double((hex >> 00) & 0xff) / 255
        )
        self.init(
            .sRGB,
            red: components.R,
            green: components.G,
            blue: components.B,
            opacity: alpha
        )
    }
}


struct PlantDropDelegate: DropDelegate {
    @Binding var receiveID: String


        func performDrop(info: DropInfo) -> Bool {

            if let item = info.itemProviders(for: ["public.text"]).first {
                //  Load the item
                item.loadItem(forTypeIdentifier: "public.text", options: nil) { (text, err) in
                    //  Cast NSSecureCoding to Ddata
                    if let data = text as? Data {
                        //  Extract string from data
                        let inputStr = String(decoding: data, as: UTF8.self)
                        //  Conditionally change color given text string
                        receiveID = inputStr
                    }
                }
            } else {

                return false
            }

            return true
        }
}
