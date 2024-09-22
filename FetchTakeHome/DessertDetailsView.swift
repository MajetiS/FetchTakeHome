//
//  DessertFormView.swift
//  FetchTakeHome
//
//  Created by Sindhu Majeti on 9/21/24.
//

import SwiftUI


struct DessertDetailsView: View {
    @State var dessertID : String
    @StateObject var recipeViewModel = RecipeViewModel()
    
    var body: some View {
        VStack {
            Form {
                Section {
                    if recipeViewModel.isLoading {
                        ProgressView()
                    } else {
                        Text(recipeViewModel.dessertDetails.name)
                        Text(recipeViewModel.dessertDetails.instructions)
                        ForEach(recipeViewModel.dessertDetails.ingredients, id: \.id) { pair in
                            HStack {
                                Text("\(pair.ingredient)")
                                Spacer()
                                Text("\(pair.measure)")
                            }
                        }
                    }
                }
            }.navigationTitle(recipeViewModel.dessertDetails.name)
                .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear() {
            recipeViewModel.fetchDetails(dessertID: dessertID)
        }
    }
}
