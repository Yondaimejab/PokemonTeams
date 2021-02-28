//
//  HomeViewModel.swift
//  PokemonTeams
//
//  Created by Joel Alcantara burgos on 27/2/21.
//

import Foundation
import Combine

class HomeViewModel {
    @Published var pokemons: [Pokemon] = []

    init() {
        pokemons = []
    }

    func getPokemons(limit: Int = 10, offset: Int = 10) {
        // request new pokemons
        pokemons = mockPokemons
    }
}

var mockPokemons: [Pokemon] = [
    Pokemon(id: "1", name: "cataluñamon", description: "lorem ipsum amet soru alsdkjaslaksdjalsdj jasd kkaksld ", imageString: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/22.png"),

    Pokemon(id: "2", name: "cataluñamon", description: "lorem ipsum amet soru alsdkjaslaksdjalsdj jasd kkaksld ", imageString: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/22.png"),

    Pokemon(id: "3", name: "cataluñamon", description: "lorem ipsum amet soru alsdkjaslaksdjalsdj jasd kkaksld ", imageString: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/22.png"),

    Pokemon(id: "4", name: "cataluñamon", description: "lorem ipsum amet soru alsdkjaslaksdjalsdj jasd kkaksld ", imageString: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/22.png"),

    Pokemon(id: "5", name: "cataluñamon", description: "lorem ipsum amet soru alsdkjaslaksdjalsdj jasd kkaksld ", imageString: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/22.png"),
]
