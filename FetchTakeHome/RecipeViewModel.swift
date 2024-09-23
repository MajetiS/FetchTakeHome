//
//  UserViewModel.swift
//  FetchTakeHome
//
//  Created by Sindhu Majeti on 9/21/24.
//


import Foundation
import SwiftUI

/// enum to store urls for ease of modification
enum URLStrings: String {
    case urlDessert = "https://themealdb.com/api/json/v1/1/filter.php?c=Dessert"
    case urlDetails = "https://themealdb.com/api/json/v1/1/lookup.php?i="
}


/// ViewModel used to fetch data from specific urls to display desserts and their corrosponding details
class RecipeViewModel: ObservableObject {
    @Published var desserts: [Dessert] = []
    @Published var dessertDetails: DessertDetails = DessertDetails()
    
    /// used to display ProgressView as data is loading
    @State var isLoading = false
    
    private let urlDessert = URLStrings.urlDessert.rawValue
    private let urlDetails = URLStrings.urlDetails.rawValue
    
    // MARK: - Fetch Data

    /// function to fetch list of desserts and update RecipeViewModel.desserts
    func fetchDesserts() {
        guard let url = URL(string: urlDessert) else {
            print("Invalid URL.")
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
                print("Failed to decode JSON: \(String(describing: error?.localizedDescription))")
            }
        }.resume()
    }
    
    /// function to fetch DessertDetails for corresponding dessert by dessertID and update RecipeViewModel.dessertDetails
    func fetchDetails(dessertID: String) {
        guard let url = URL(string: urlDetails + dessertID) else {
            print("Invalid URL.")
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
                print("Error decoding JSON: \(String(describing: error.localizedDescription))")
            }
        }.resume()
    }
}



