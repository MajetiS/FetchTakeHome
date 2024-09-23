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

/// combines the measure and ingredient for ease of use
struct IngredientMeasure: Identifiable, Codable, Equatable {
    var id: Int
    var ingredient: String
    var measure: String
}

/// custom CodingKey used to help parse ingredients and measures
struct DynamicCodingKeys: CodingKey {
    var stringValue: String
    var intValue: Int? = nil
    
    init?(stringValue: String) {
        self.stringValue = stringValue
    }
    
    init?(intValue: Int) {
        return nil
    }
}

struct DessertDetails: Identifiable, Codable {
    let id: String
    let name: String
    let instructions: String
    let ingredients: [IngredientMeasure]
    
    enum CodingKeys: String, CodingKey {
        case id = "idMeal"
        case name = "strMeal"
        case instructions = "strInstructions"
    }
    
    // MARK: - Initalizers
    
    init(_ id: String = "",_ name: String = "", _ instructions: String = "", _ ingredients: [IngredientMeasure] = []) {
        self.id = id
        self.name = name
        self.instructions = instructions
        self.ingredients = ingredients
    }
    
    /// Custom decoding to handle ingredients and measures
    init(from decoder: Decoder) throws {
        
        /// decode id, name, instructions using CodingKeys
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        instructions = try container.decode(String.self, forKey: .instructions)
        
        /// additionalContainer used specifically for DynamicCodingKeys
        let additionalContainer = try decoder.container(keyedBy: DynamicCodingKeys.self)
        var ingredientsArray: [IngredientMeasure] = []
        
        for index in 1...20 {
            let ingredientKey = "strIngredient\(index)"
            let measureKey = "strMeasure\(index)"
            
            /// decode ingredient and measure
            guard
                let ingredientCodingKey = DynamicCodingKeys(stringValue: ingredientKey),
                let measureCodingKey = DynamicCodingKeys(stringValue: measureKey),
                let ingredient = try additionalContainer.decodeIfPresent(String.self, forKey: ingredientCodingKey),
                let measure = try additionalContainer.decodeIfPresent(String.self, forKey: measureCodingKey)
            else {
                print("Could not encode Ingredients or Measures")
                break
            }
            
            /// check that ingredient and measure is not empty before adding to ingredientsArray
             if !ingredient.isEmpty, !measure.isEmpty {
                let ingredient = IngredientMeasure(id: index, ingredient: ingredient, measure: measure)
                ingredientsArray.append(ingredient)
            }
        }
        
        ingredients = ingredientsArray
    }
    
    // MARK: - Functions
    
    /// Custom encoding to handle ingredients and measures dynamically
    func encode(to encoder: Encoder) throws {
        /// encode id, name, instructions using CodingKeys
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(instructions, forKey: .instructions)
        
        /// additionalContainer used specifically for DynamicCodingKeys
        var additionalContainer = encoder.container(keyedBy: DynamicCodingKeys.self)
        
        for (index, ingredient) in ingredients.enumerated() where index < 20 {
            let ingredientKey = "strIngredient\(index + 1)"
            let measureKey = "strMeasure\(index + 1)"
            
            guard let ingredientCodingKey = DynamicCodingKeys(stringValue: ingredientKey),
               let measureCodingKey = DynamicCodingKeys(stringValue: measureKey)
            else {
                print("Could not encode Ingredients or Measures")
                break
            }
            
            try additionalContainer.encode(ingredient.ingredient, forKey: ingredientCodingKey)
            try additionalContainer.encode(ingredient.measure, forKey: measureCodingKey)
        }
    }
}
