//
//  HomeViewModel.swift
//  PokemonTeams
//
//  Created by Joel Alcantara burgos on 27/2/21.
//

import Foundation
import Combine

class HomeViewModel {
    private var cachedPokemons: [Pokemon] = []
    @Published var pokemons: [Pokemon] = []
    @Published var error: Error?

    var pokemonLimitMultiple = 1
    var pokemonOffsetMultiple = 0

    private var pokemonService: PokemonProviding
    private var serviceSubscriber = Set<AnyCancellable>()

    init(pokemonService: PokemonProviding = PokemonApiProvider.shared) {
        pokemons = []
        self.pokemonService = pokemonService
    }

    func getNextPokemons() {
        pokemonOffsetMultiple += 1
        getPokemons(limit: pokemonLimitMultiple, offset: pokemonOffsetMultiple)
    }

    func getPreviusPokemons() -> Bool {
        pokemonOffsetMultiple -= 1
        guard pokemonOffsetMultiple >= 1 else {
            pokemonOffsetMultiple = 1
            return false
        }
        getPokemons(limit: pokemonLimitMultiple, offset: pokemonOffsetMultiple)
        return true
    }

    private func getPokemons(limit: Int, offset: Int) {
        guard cachedPokemons.count < ((offset * 20) + 20) else {
            let lowerBound = (offset * 20)
            let upperBound = ((offset * 20) + 20)
            pokemons = Array(cachedPokemons[lowerBound..<upperBound])
            return
        }

        pokemonService.getPokemons(limit: limit, offset: offset)
            .sink { (completion) in
                switch completion {
                case .failure(let error):
                    self.error = error
                    print(error.localizedDescription + "Error on pokemons")
                case .finished:
                    print("Successfully finish request")
                }
            } receiveValue: { [weak self] (pokemonList) in
                self?.pokemons = pokemonList
                self?.cachedPokemons.append(contentsOf: pokemonList)
            }.store(in: &serviceSubscriber)
    }
}
