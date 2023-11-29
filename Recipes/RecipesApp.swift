//
//  RecipesApp.swift
//  Recipes
//
//  Created by Noelia Root on 11/16/23.
//

import SwiftUI
import SwiftData
import Amplify
import AWSCognitoAuthPlugin
import AWSS3StoragePlugin

@main
struct RecipesApp: App {
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Recipe.self,
            Direction.self,
            Ingredient.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
        var body: some Scene {
            WindowGroup {
                ContentView()
                    .modelContainer(sharedModelContainer)
            }
        }
    
    init () {
        configureAmplify()
    }
       
       private func configureAmplify() {
           do {
               print("about to try cognito")
               try Amplify.add(plugin: AWSCognitoAuthPlugin())
               print("about to try s3")
               try Amplify.add(plugin: AWSS3StoragePlugin())
               print("about to try configure")
               try Amplify.configure()
               print("Successfully configured Amplify")
               
           } catch {
               print("Could not configure Amplify", error)
           }
       }
}
