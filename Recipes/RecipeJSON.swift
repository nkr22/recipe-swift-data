//
//  RecipeJSON.swift
//  Recipes
//
//  Created by Noelia Root on 11/26/23.
//

import Foundation

//See https://stackoverflow.com/questions/24410881/reading-in-a-json-file-using-swift
struct ResponseData: Codable {
    var recipes: [RecipeJSON]
}

struct RecipeJSON: Codable {
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
    var directions: [Direction]
    var ingredients: [Ingredient]
    
//    init(title: String, author: String, dateCreated: String, expertiseRequired: ExpertiseLevel, dateLastViewed: String, sourceURL: String?, prepTime: Int? = nil, cookTime: Int? = nil, servings: Double? = nil, currentScale: Double, isFavorited: Bool, starRating: Int? = nil, imageURL: String? = nil, notes: String? = nil, directions: [Direction], ingredients: [Ingredient]) {
//        self.title = title
//        self.author = author
//        self.dateCreated = dateCreated
//        self.expertiseRequired = expertiseRequired
//        self.dateLastViewed = dateLastViewed
//        self.sourceURL = sourceURL
//        self.prepTime = prepTime
//        self.cookTime = cookTime
//        self.servings = servings
//        self.currentScale = currentScale
//        self.isFavorited = isFavorited
//        self.starRating = starRating
//        self.imageURL = imageURL
//        self.notes = notes
//        self.directions = directions
//        self.ingredients = ingredients
//    }
}

func loadJson(filename fileName: String) -> [RecipeJSON]? {
    if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
        do {
            let data = try Data(contentsOf: url)
            let jsonData = try JSONDecoder().decode(ResponseData.self, from: data)
            
            return jsonData.recipes
        } catch {
            print("error:\(error)")
        }
    }
    return nil
}
