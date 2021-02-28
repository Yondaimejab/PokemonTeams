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
    private var customSubscriber: PokemonRequestSubscriber?

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

    func getPokemon(id: String? = nil, name: String? = nil) {
        pokemonService.getPokemon(id: id, name: name)
            .sink { (completion) in
                switch completion {
                case .failure(let error):
                    self.error = error
                case .finished:
                    print("Successfully finish request")
                }
            } receiveValue: { [weak self] (pokemon) in
                // TODO handleThis
                print(pokemon.name)
            }
    }
}


class PokemonRequestSubscriber: Subscriber {
    func receive(_ input: [Pokemon]) -> Subscribers.Demand {
        return .none
    }

    func receive(completion: Subscribers.Completion<Error>) {
        print("Publisher Completed successfully")
    }

    typealias Input = [Pokemon]

    typealias Failure = Error

    func receive(subscription: Subscription) {
        subscription.request(demand)
    }

    var demand: Subscribers.Demand = .unlimited

    init(demand: Subscribers.Demand) {
        self.demand = demand
    }
}
