//
//  PokemonProviding.swift
//  PokemonTeams
//
//  Created by Joel Alcantara burgos on 28/2/21.
//

import Foundation
import Combine

protocol PokemonProviding {
    func getPokemons(limit: Int?, offset: Int?) -> AnyPublisher<[Pokemon], Error>
    func getPokemon(id: String?, name: String?) -> AnyPublisher<Pokemon, Error>
}
