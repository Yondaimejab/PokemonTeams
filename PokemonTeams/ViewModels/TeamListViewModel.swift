//
//  TeamListViewModel.swift
//  PokemonTeams
//
//  Created by Joel Alcantara burgos on 28/2/21.
//

import Foundation
import Combine

class TeamListViewModel {
    private var pokemonProvider: PokemonProviding
    private var teamsDataProvider: TeamDataProviding
    @Published var listOfPokemonTeams: [Team] = []
    private let teamsPublisher = PassthroughSubject<(Pokemon, String), Never>()

    private var teamRequestSubscribers = Set<AnyCancellable>()
    private var pokemonSubscriber: AnyCancellable?

    init(pokemonProvider: PokemonProviding = PokemonApiProvider.shared, teamsDataProvider: TeamDataProviding = FirestoreTeamDataProvider.shared) {
        self.pokemonProvider = pokemonProvider
        self.teamsDataProvider = teamsDataProvider
    }

    func listTeams(for user: User) {
        teamRequestSubscribers.removeAll()


        teamsDataProvider.listTeams(for: user.id)
            .sink { (completion) in
                print(completion)
            } receiveValue: { [weak self] (listOfRepresentable) in
                guard let self = self else { return }

                var prefix = 0
                for item in listOfRepresentable {
                    prefix += item.pokemonIDs.count
                    for ids in item.pokemonIDs {
                        self.pokemonProvider.getPokemon(id: ids, name: nil)
                            .sink(receiveCompletion: ({ print($0) })) { (pokemon) in
                                self.teamsPublisher.send((pokemon, item.id))
                            }.store(in: &self.teamRequestSubscribers)
                    }
                }

                self.teamsPublisher.prefix(prefix).collect()
                    .sink { (list: [(pokemon: Pokemon, id: String)]) in
                        let teamList = listOfRepresentable.compactMap { (item) -> Team? in
                            return try? Team(id: item.id, name: item.name, pokemons: list.filter { $0.id == item.id}.map { $0.pokemon }, user: user)
                        }

                        self.listOfPokemonTeams.append(contentsOf: teamList)
                    }.store(in: &self.teamRequestSubscribers)

            }.store(in: &teamRequestSubscribers)
    }

    func deleteTeam(team: Team) {
        teamsDataProvider.delete(team: team.id)
            .sink(receiveCompletion: ({print($0)})) { (result) in
                print(result)
                self.listOfPokemonTeams.removeAll(where: ({ $0 == team}))
            }.store(in: &self.teamRequestSubscribers)
    }
}
