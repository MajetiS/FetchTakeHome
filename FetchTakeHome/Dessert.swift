//
//  Dessert.swift
//  FetchTakeHome
//
//  Created by Sindhu Majeti on 9/21/24.
//

import Foundation

struct DessertResponse: Codable {
    let meals: [Dessert]
}

struct Dessert: Identifiable, Codable {
    let id: String
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case id = "idMeal"
        case name = "strMeal"
    }
}
