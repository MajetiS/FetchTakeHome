//
//  FetchTakeHomeTests.swift
//  FetchTakeHomeTests
//
//  Created by Sindhu Majeti on 9/21/24.
//

import XCTest
@testable import FetchTakeHome

struct FetchTakeHomeTests {
    
    // MARK: - Helpers
    
    func jsonData(from dictionary: [String: Any]) throws -> Data {
        return try JSONSerialization.data(withJSONObject: dictionary, options: [])
    }
    
    /// Helper method to compare two DessertDetails instances
    func XCTAssertEqualDessertDetails(_ lhs: DessertDetails, _ rhs: DessertDetails) {
        XCTAssertEqual(lhs.id, rhs.id, "IDs do not match")
        XCTAssertEqual(lhs.name, rhs.name, "Names do not match")
        XCTAssertEqual(lhs.instructions, rhs.instructions, "Instructions do not match")
        XCTAssertEqual(lhs.ingredients, rhs.ingredients, "Ingredients do not match")
    }
    
    // MARK: - Tests
    
    func testDecodingWithEmptyIngredientsAndMeasures() throws {
            var jsonDict: [String: Any] = [
                "idMeal": "54321",
                "strMeal": "Empty Dessert",
                "strInstructions": "No ingredients."
            ]
            
            jsonDict["strIngredient1"] = "Flour"
            jsonDict["strMeasure1"] = "2 cups"
            jsonDict["strIngredient2"] = "" // Should be ignored
            jsonDict["strMeasure2"] = "1 cup"
            jsonDict["strIngredient3"] = "Sugar"
            jsonDict["strMeasure3"] = "" // Should be ignored
            jsonDict["strIngredient4"] = "Butter"
            jsonDict["strMeasure4"] = "100g"
            
            let data = try jsonData(from: jsonDict)
            let decoder = JSONDecoder()
            let dessert = try decoder.decode(DessertDetails.self, from: data)
            
            XCTAssertEqual(dessert.id, "54321")
            XCTAssertEqual(dessert.name, "Empty Dessert")
            XCTAssertEqual(dessert.instructions, "No ingredients.")
            XCTAssertEqual(dessert.ingredients.count, 2, "Should decode only valid ingredients")
            
            XCTAssertEqual(dessert.ingredients[0], IngredientMeasure(id: 1, ingredient: "Flour", measure: "2 cups"))
            XCTAssertEqual(dessert.ingredients[1], IngredientMeasure(id: 4, ingredient: "Butter", measure: "100g"))
        }

    func testEncodingAndDecodingCycle() throws {
        let ingredients = [
            IngredientMeasure(id: 1, ingredient: "Sugar", measure: "100g"),
            IngredientMeasure(id: 2, ingredient: "Butter", measure: "200g")
        ]
        let originalDessert = DessertDetails("22222", "Cookies", "Bake until golden.", ingredients)
        
        // Encode to JSON
        let encoder = JSONEncoder()
        let data = try encoder.encode(originalDessert)
        
        // Decode back to DessertDetails
        let decoder = JSONDecoder()
        let decodedDessert = try decoder.decode(DessertDetails.self, from: data)
        
        XCTAssertEqualDessertDetails(originalDessert, decodedDessert)
    }
    
    func testDecodingWithInvalidKeys() throws {
        let jsonDict: [String: Any] = [
            "idMeal": "99999",
            "strMeal": "Mystery Dessert",
            "strInstructions": "Unknown recipe.",
            "strIngredient21": "Ghost Ingredient", // Invalid, beyond 20
            "strMeasure21": "1 phantom"
        ]
        
        let data = try jsonData(from: jsonDict)
        let decoder = JSONDecoder()
        let dessert = try decoder.decode(DessertDetails.self, from: data)
        
        XCTAssertEqual(dessert.id, "99999")
        XCTAssertEqual(dessert.name, "Mystery Dessert")
        XCTAssertEqual(dessert.instructions, "Unknown recipe.")
        XCTAssertTrue(dessert.ingredients.isEmpty, "Should ignore ingredients beyond 20")
    }
}
