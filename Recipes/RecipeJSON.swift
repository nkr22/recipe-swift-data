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
    var prepTime: PrepTime?
    var cookTime: CookTime?
    var servings: Double?
    var currentScale: Double
    var isFavorited: Bool
    var starRating: Int?
    var imageURL: Data?
    var notes: String?
    var directions: [Direction]
    var ingredients: [Ingredient]
    var categories: [Category]
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

struct CategoryResponseData: Codable {
    var categories: [CategoryJSON]
}

struct CategoryJSON: Codable {
    var name: String
}

func loadCategoryJson(filename fileName: String) -> [CategoryJSON]? {
    if let url = Bundle.main.url(forResource: fileName, withExtension: ".json") {
        do {
            let data = try Data(contentsOf: url)
            let jsonData = try JSONDecoder().decode(CategoryResponseData.self, from: data)
            return jsonData.categories
        } catch {
            print("error:\(error)")
        }
    }
    return nil
}
