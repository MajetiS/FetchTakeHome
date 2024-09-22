//
//  ContentView.swift
//  FetchTakeHome
//
//  Created by Sindhu Majeti on 9/21/24.
//

import SwiftUI

struct DessertView: View {
    @StateObject var recipeViewModel = RecipeViewModel()
    
    var body: some View {
        NavigationStack() {
            VStack {
                if recipeViewModel.isLoading {
                    ProgressView()
                } else {
                    List(recipeViewModel.desserts, id: \.id) { dessert in
                        NavigationLink(value: dessert.id) {
                            Text(dessert.name)
                        }
                    }
                }
            }.navigationDestination(for: String.self) { id in
                DessertDetailsView(dessertID: id)
            }
            .navigationTitle("Desserts")
            .onAppear() {
                recipeViewModel.fetchDesserts()
            }
        }
    }
}

