//
//  UserViewModel.swift
//  FetchTakeHome
//
//  Created by Sindhu Majeti on 9/21/24.
//


import Foundation
import SwiftUI

class RecipeViewModel: ObservableObject {
    @Published var desserts: [Dessert] = []
    @Published var dessertDetails: DessertDetails = DessertDetails()
    
    @State var isLoading = false
    @State var errorMessage: String?
    
    private let urlDessert = "https://themealdb.com/api/json/v1/1/filter.php?c=Dessert"
    private let urlDetails = "https://themealdb.com/api/json/v1/1/lookup.php?i="

    func fetchDesserts() {
        guard let url = URL(string: urlDessert) else {
            self.errorMessage = "Invalid URL."
            return
        }
        
        self.isLoading = true
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
               self.isLoading = false
            }

            if let error = error {
                print("Error fetching data: \(error)")
                return
            }

            guard let data = data else {
                print("No data received")
                return
            }
            
            if let decodedResponse = try? JSONDecoder().decode(DessertResponse.self, from: data) {
                DispatchQueue.main.async {
                    self.desserts = decodedResponse.meals.sorted(by: { $0.name < $1.name })
                }
            } else {
                self.errorMessage = "Failed to decode JSON: \(String(describing: error?.localizedDescription))"
            }
        }.resume()
    }
    
    
    func fetchDetails(dessertID: String) {
        guard let url = URL(string: urlDetails + dessertID) else {
            self.errorMessage = "Invalid URL."
            return
        }
        
        self.isLoading = true
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
               self.isLoading = false
            }

            if let error = error {
                print("Error fetching data: \(error)")
                return
            }

            guard let data = data else {
                print("No data received")
                return
            }
    
            do {
                let mealResponse = try JSONDecoder().decode(DetailResponse.self, from: data)
                DispatchQueue.main.async {
                    self.dessertDetails = mealResponse.meals.first ?? DessertDetails()
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }.resume()
    }
}



