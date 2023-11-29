//
//  Item.swift
//  Recipes
//
//  Created by Noelia Root on 11/16/23.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}

//final class Item {
//    var title: String
//    var ingredients: String
//    var instruction: String
//    
//    init(title: String, ingredients: String, instruction: String) {
//        self.title = title
//        self.ingredients = ingredients
//        self.instruction = instruction
//    }
//}
