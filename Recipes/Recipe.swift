//
//  Recipe.swift
//  Recipes
//
//  Created by Noelia Root on 11/26/23.
//

import Foundation
import SwiftData

@Model
class Recipe {
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
    var imageURL: String?
    var notes: String?
    @Relationship(deleteRule: .cascade)
    var directions: [Direction] = []
    @Relationship(deleteRule: .cascade)
    var ingredients: [Ingredient] = []
    
    init(title: String, author: String, dateCreated: String, expertiseRequired: ExpertiseLevel, dateLastViewed: String, sourceURL: String?, prepTime: Int? , cookTime: Int? , servings: Double? , currentScale: Double, isFavorited: Bool, starRating: Int?, imageURL: String? , notes: String? , directions: [Direction], ingredients: [Ingredient]) {
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
    }

}

enum ExpertiseLevel: String, Codable, CaseIterable {
    case beginner, moderate, advanced, expert
}


@Model
class Direction: Codable, Hashable {
    var order: Int
    var direction: String
    
    @Relationship(inverse: \Recipe.directions)
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
    var quantity: String
    var ingredient: String
    var notes: String

    @Relationship(inverse: \Recipe.ingredients)
        var recipe: Recipe?

    enum CodingKeys: CodingKey {
        case quantity, ingredient, notes
    }

    init(quantity: String, ingredient: String, notes: String) {
        self.quantity = quantity
        self.ingredient = ingredient
        self.notes = notes
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.quantity = try container.decode(String.self, forKey: .quantity)
        self.ingredient = try container.decode(String.self, forKey: .ingredient)
        self.notes = try container.decode(String.self, forKey: .notes)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(quantity, forKey: .quantity)
        try container.encode(ingredient, forKey: .ingredient)
        try container.encode(notes, forKey: .notes)
    }
}


