//
//  FirestoreTeamRepresentation.swift
//  PokemonTeams
//
//  Created by Joel Alcantara burgos on 28/2/21.
//

import Foundation

class FirestoreTeamRepresentation: Codable {
    var id: String
    var name: String
    var userID: String
    var pokemonIDs: [String]

    init(id: String, name: String, userID: String, pokemonIDs: [String]) {
        self.id = id
        self.name = name
        self.userID = userID
        self.pokemonIDs = pokemonIDs
    }

    var data: [String: Any] {
        return [
            "id": id,
            "name": name,
            "userID": userID,
            "pokemonIDs": pokemonIDs
        ]
    }
}
