//
//  CreateTeamViewModel.swift
//  PokemonTeams
//
//  Created by Joel Alcantara burgos on 28/2/21.
//

import Foundation
import Combine

class CreateTeamViewModel {
    private var pokemonProvider: PokemonProviding
    private var teamsDataProvider: TeamDataProviding
    @Published var selectedPokemonsForTeam: [Pokemon] = []

    private var teamRequestSubscribers = Set<AnyCancellable>()
    private var pokemonSubscriber: AnyCancellable?

    init(pokemonProvider: PokemonProviding = PokemonApiProvider.shared, teamsDataProvider: TeamDataProviding = FirestoreTeamDataProvider.shared) {
        self.pokemonProvider = pokemonProvider
        self.teamsDataProvider = teamsDataProvider
    }

    func createTeam(with name: String, user: String) {
        let teamRepresentable = FirestoreTeamRepresentation(id: "", name: name, userID: user, pokemonIDs: selectedPokemonsForTeam.map({$0.id ?? ""}))
        teamsDataProvider.create(team: teamRepresentable)
            .sink { (completion) in
            print(completion)
        } receiveValue: { (result) in
            print(result)
        }.store(in: &teamRequestSubscribers)
    }

    func update(teamId: String, with name: String, user: String) {
        let teamRepresentable = FirestoreTeamRepresentation(id: teamId, name: name, userID: user, pokemonIDs: selectedPokemonsForTeam.map({$0.id ?? ""}))
        teamsDataProvider.update(team: teamRepresentable).sink { (completion) in
            print(completion)
        } receiveValue: { (result) in
            print(result)
        }.store(in: &teamRequestSubscribers)
    }

    func searchPokemon(with name: String) {
        pokemonSubscriber = pokemonProvider.getPokemon(id: nil, name: name)
            .sink(receiveCompletion: { (completion) in
                print(completion)
            }, receiveValue: { [weak self] (pokemon) in
                guard let self = self else {return}
                if !self.selectedPokemonsForTeam.contains(pokemon) {
                    self.selectedPokemonsForTeam.append(pokemon)
                }
            })
    }
}
