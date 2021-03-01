//
//  Teams.swift
//  PokemonTeams
//
//  Created by Joel Alcantara burgos on 28/2/21.
//

import Foundation

class Team: Codable, Hashable, Equatable {
    static func == (lhs: Team, rhs: Team) -> Bool {
        lhs.id == rhs.id
    }

    enum TeamError: Error {
        case minimumPokemonsRequiered

        var localizedDescription: String {
            return "Required amount of pokemons not provided -> #3"
        }
    }

    var id: String
    var name: String
    var user: User
    private(set) var pokemons: [Pokemon]

    init(id: String, name: String,  pokemons: [Pokemon], user: User) throws {
        guard pokemons.count >= 3 else {
            throw TeamError.minimumPokemonsRequiered
        }

        self.pokemons = pokemons
        self.user = user
        self.id = id
        self.name = name
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
