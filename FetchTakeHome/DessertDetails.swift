//
//  DessertDetails.swift
//  FetchTakeHome
//
//  Created by Sindhu Majeti on 9/21/24.
//

import Foundation

struct DetailResponse: Codable {
    let meals: [DessertDetails]
}

struct Ingredient: Identifiable, Codable {
    var id: Int
    var ingredient: String
    var measure: String
}

struct DessertDetails: Identifiable, Codable {
    let id: String
    let name: String
    let instructions: String
    let ingredients: [Ingredient]
    
    enum CodingKeys: String, CodingKey {
        case id = "idMeal"
        case name = "strMeal"
        case instructions = "strInstructions"
    }
    
    init() {
        id = ""
        name = ""
        instructions = ""
        ingredients = []
    }
    
    // Custom decoding to handle ingredients and measures
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        instructions = try container.decode(String.self, forKey: .instructions)
        
        var ingredientsArray: [Ingredient] = []
        
        // custom decode the ingredients and measures
        for index in 1...20 {
            let ingredientKey = "strIngredient\(index)"
            let measureKey = "strMeasure\(index)"
            
            if 
                let ingredientCodingKey = CodingKeys(stringValue: ingredientKey),
                let measureCodingKey = CodingKeys(stringValue: measureKey),
                // try to decode ingredient and measure
                let ingredient = try container.decodeIfPresent(String.self, forKey: ingredientCodingKey),
                let measure = try container.decodeIfPresent(String.self, forKey: measureCodingKey),
                // check that ingredient and measure is not empty
                !ingredient.isEmpty, !measure.isEmpty {
                    // add ingredient and measure to ingredientsArray
                    let ingredient = Ingredient(id: index, ingredient: ingredient, measure: measure)
                    ingredientsArray.append(ingredient)
            }
        }
        
        ingredients = ingredientsArray
    }
        
    // Implemented for Encodable conformance
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(instructions, forKey: .instructions)
        
        for (index, ingredient) in ingredients.enumerated() where index < 20 {
            let ingredientKey = "strIngredient\(index + 1)"
            let measureKey = "strMeasure\(index + 1)"
            
            try container.encode(ingredient.ingredient, forKey: CodingKeys(stringValue: ingredientKey)!)
            try container.encode(ingredient.measure, forKey: CodingKeys(stringValue: measureKey)!)
        }
    }
}
