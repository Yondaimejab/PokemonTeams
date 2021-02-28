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

    private var teamRequestSubscribers = Set<AnyCancellable>()

    init(pokemonProvider: PokemonProviding = PokemonApiProvider.shared, teamsDataProvider: TeamDataProviding = FirestoreTeamDataProvider.shared) {
        self.pokemonProvider = pokemonProvider
        self.teamsDataProvider = teamsDataProvider
    }

    func create(team: Team) {
        teamsDataProvider.create(team: team).sink { (completion) in
            print(completion)
        } receiveValue: { (result) in
            print(result)
        }.store(in: &teamRequestSubscribers)
    }

    func update(team: Team) {
        teamsDataProvider.update(team: team).sink { (completion) in
            print(completion)
        } receiveValue: { (result) in
            print(result)
        }.store(in: &teamRequestSubscribers)
    }

    func delete(team id: String) {
        teamsDataProvider.delete(team: id).sink { (completion) in
            print(completion)
        } receiveValue: { (result) in
            print(result)
        }.store(in: &teamRequestSubscribers)
    }
}
