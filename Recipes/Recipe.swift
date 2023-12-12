//
//  Recipe.swift
//  Recipes
//
//  Created by Noelia Root on 11/26/23.
//

import Foundation
import SwiftData

@Model
class Recipe: Codable {
    var title: String
    var author: String
    var dateCreated: String
    var expertiseRequired: ExpertiseLevel
    var dateLastViewed: String
    var sourceURL: String?
    var prepTime: Int?
    var cookTime: Int?
    var servings: Double?
    var currentScale: Double
    var isFavorited: Bool
    var starRating: Int?
    var imageURL: Data?
    var notes: String?
    @Relationship(deleteRule: .cascade)
    var directions: [Direction] = []
    @Relationship(deleteRule: .cascade)
    var ingredients: [Ingredient] = []
    @Relationship(deleteRule: .nullify)
    var categories: [Category] = []
    
    enum CodingKeys: String, CodingKey {
        case title, author, dateCreated, expertiseRequired, dateLastViewed, sourceURL, prepTime, cookTime, servings, currentScale, isFavorited, starRating, imageURL, notes, directions, ingredients, categories
    }
    
    required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.title = try container.decode(String.self, forKey: .title)
            self.author = try container.decode(String.self, forKey: .author)
            self.dateCreated = try container.decode(String.self, forKey: .dateCreated)
            self.expertiseRequired = try container.decode(ExpertiseLevel.self, forKey: .expertiseRequired)
            self.dateLastViewed = try container.decode(String.self, forKey: .dateLastViewed)
            self.sourceURL = try container.decodeIfPresent(String.self, forKey: .sourceURL)
            self.prepTime = try container.decodeIfPresent(Int.self, forKey: .prepTime)
            self.cookTime = try container.decodeIfPresent(Int.self, forKey: .cookTime)
            self.servings = try container.decodeIfPresent(Double.self, forKey: .servings)
            self.currentScale = try container.decode(Double.self, forKey: .currentScale)
            self.isFavorited = try container.decode(Bool.self, forKey: .isFavorited)
            self.starRating = try container.decodeIfPresent(Int.self, forKey: .starRating)
            self.imageURL = try container.decodeIfPresent(Data.self, forKey: .imageURL)
            self.notes = try container.decodeIfPresent(String.self, forKey: .notes)
            self.directions = try container.decode([Direction].self, forKey: .directions)
            self.ingredients = try container.decode([Ingredient].self, forKey: .ingredients)
            self.categories = try container.decode([Category].self, forKey: .categories)
        }

        // Custom encoder to handle the encoding to an external representation (like JSON)
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(title, forKey: .title)
            try container.encode(author, forKey: .author)
            try container.encode(dateCreated, forKey: .dateCreated)
            try container.encode(expertiseRequired, forKey: .expertiseRequired)
            try container.encode(dateLastViewed, forKey: .dateLastViewed)
            try container.encodeIfPresent(sourceURL, forKey: .sourceURL)
            try container.encodeIfPresent(prepTime, forKey: .prepTime)
            try container.encodeIfPresent(cookTime, forKey: .cookTime)
            try container.encodeIfPresent(servings, forKey: .servings)
            try container.encode(currentScale, forKey: .currentScale)
            try container.encode(isFavorited, forKey: .isFavorited)
            try container.encodeIfPresent(starRating, forKey: .starRating)
            try container.encodeIfPresent(imageURL, forKey: .imageURL)
            try container.encodeIfPresent(notes, forKey: .notes)
            try container.encode(directions, forKey: .directions)
            try container.encode(ingredients, forKey: .ingredients)
            try container.encode(categories, forKey: .categories)
        }

    
    init(title: String, author: String, dateCreated: String, expertiseRequired: ExpertiseLevel, dateLastViewed: String, sourceURL: String?, prepTime: Int? , cookTime: Int? , servings: Double? , currentScale: Double, isFavorited: Bool, starRating: Int?, imageURL: Data? , notes: String? , directions: [Direction], ingredients: [Ingredient], categories: [Category]) {
        self.title = title
        self.author = author
        self.dateCreated = dateCreated
        self.expertiseRequired = expertiseRequired
        self.dateLastViewed = dateLastViewed
        self.sourceURL = sourceURL
        self.prepTime = prepTime
        self.cookTime = cookTime
        self.servings = servings
        self.currentScale = currentScale
        self.isFavorited = isFavorited
        self.starRating = starRating
        self.imageURL = imageURL
        self.notes = notes
        self.directions = directions
        self.ingredients = ingredients
        self.categories = categories
    }

}

enum ExpertiseLevel: String, Codable, CaseIterable {
    case beginner, moderate, advanced, expert
}


@Model
class Direction: Codable, Hashable {
    var order: Int
    var direction: String
    
    @Relationship(deleteRule: .cascade, inverse: \Recipe.directions)
        var recipe: Recipe?

    enum CodingKeys: CodingKey {
        case order, direction
    }

    init(order: Int, direction: String) {
        self.order = order
        self.direction = direction
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.order = try container.decode(Int.self, forKey: .order)
        self.direction = try container.decode(String.self, forKey: .direction)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(order, forKey: .order)
        try container.encode(direction, forKey: .direction)
    }
}


@Model
class Ingredient: Codable, Hashable {
    var amount: String?
    var unit: String?
    var ingredient: String
    var notes: String?
        

    @Relationship(deleteRule: .cascade, inverse: \Recipe.ingredients)
        var recipe: Recipe?

    enum CodingKeys: CodingKey {
        case amount, unit, ingredient, notes
    }

    init(amount: String?, unit: String?, ingredient: String, notes: String?) {
        self.amount = amount
        self.unit = unit
        self.ingredient = ingredient
        self.notes = notes
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.amount = try container.decode(String.self, forKey: .amount)
        self.unit = try container.decode(String.self, forKey: .unit)
        self.ingredient = try container.decode(String.self, forKey: .ingredient)
        self.notes = try container.decodeIfPresent(String.self, forKey: .notes)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(amount, forKey: .amount)
        try container.encode(unit, forKey: .unit)
        try container.encode(ingredient, forKey: .ingredient)
        try container.encodeIfPresent(notes, forKey: .notes)
    }
}

@Model
class Category: Identifiable, Codable, Hashable {
    var id: UUID? = UUID()
    @Attribute(.unique) var name: String
    
    @Relationship(deleteRule: .nullify, inverse: \Recipe.categories) var recipes: [Recipe] = []
    
    init(name: String) {
        self.name = name
    }
    
    enum CodingKeys: CodingKey {
        case name
        case recipes
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
     
    }
}


