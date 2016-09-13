//
//  CoreDataHelper.swift
//  PokemonGo
//
//  Created by Juan Gabriel Gomila Salas on 1/9/16.
//  Copyright © 2016 Juan Gabriel Gomila Salas. All rights reserved.
//

import UIKit
import CoreData

func createAllThePokemons () {

    createPokemon(name: "Abra", with: "abra", frequency: 70)
    createPokemon(name: "Bellsprout", with: "bellsprout", frequency: 80)
    createPokemon(name: "Bullbasaur", with: "bullbasaur", frequency: 22)
    createPokemon(name: "Caterpie", with: "caterpie", frequency: 92)
    createPokemon(name: "Charmander", with: "charmander", frequency: 17)
    createPokemon(name: "Jigglypuff", with: "jigglypuff", frequency: 67)
    createPokemon(name: "Meowth", with: "meowth", frequency: 62)
    createPokemon(name: "Mew", with: "mew", frequency: 1)
    createPokemon(name: "Pikachu", with: "pikachu-2", frequency: 8)
    createPokemon(name: "Squirtle", with: "squirtle", frequency: 20)
    createPokemon(name: "Snorlax", with: "snorlax", frequency: 3)
    createPokemon(name: "Zubat", with: "zubat", frequency: 100)
    createPokemon(name: "Venonat", with: "venonat", frequency: 76)
    createPokemon(name: "Weedle", with: "weedle", frequency: 88)
    
   (UIApplication.shared.delegate as! AppDelegate).saveContext()
    
}


func createPokemon(name:String, with imageNamed:String, frequency: Int ){
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    let pokemon = Pokemon(context: context)
    pokemon.name = name
    pokemon.imageFileName = imageNamed
    pokemon.frequency = Int16(frequency)
}

/*func createAndCaughtPokemon(name:String, with imageNamed:String){
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let pokemon = Pokemon(context: context)
    pokemon.name = name
    pokemon.imageFileName = imageNamed
    pokemon.timesCaught = 1
    
    (UIApplication.shared.delegate as! AppDelegate).saveContext()
}*/


func getAllThePokemons() -> [Pokemon] {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    do {
        let pokemons = try context.fetch(Pokemon.fetchRequest()) as! [Pokemon]
        if pokemons.count == 0 {
            createAllThePokemons()
            return getAllThePokemons()
        }
        return pokemons
    } catch {
        print("Ha habido un problema al recuperar los pokemon de Core Data")
    }
    return []
}


func getAllCaughtPokemons() -> [Pokemon] {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  
    let fetchRequest = Pokemon.fetchRequest() as NSFetchRequest<Pokemon>
    fetchRequest.predicate = NSPredicate(format: "timesCaught > %d", 0)
    
    do {
        let pokemons = try context.fetch(fetchRequest) as [Pokemon]
        return pokemons
    } catch {
        print("Ha habido un problema al recuperar los pokemon de Core Data")
    }
    return []
}


func getAllUncaughtPokemons() -> [Pokemon] {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let fetchRequest = Pokemon.fetchRequest() as NSFetchRequest<Pokemon>
    fetchRequest.predicate = NSPredicate(format: "timesCaught == %d", 0)
    
    do {
        let pokemons = try context.fetch(fetchRequest) as [Pokemon]
        return pokemons
    } catch {
        print("Ha habido un problema al recuperar los pokemon de Core Data")
    }
    return []
}










