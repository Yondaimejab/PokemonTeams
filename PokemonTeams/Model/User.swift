//
//  User.swift
//  PokemonTeams
//
//  Created by Joel Alcantara burgos on 27/2/21.
//

import Foundation

class User: Codable {
    var id: String
    var name: String
    var lastName: String
    var email: String
    var password: String

    init(id: String, name: String, lastName: String, email: String, password: String) {
        self.name = name
        self.lastName = lastName
        self.email = email
        self.id = id
        self.password = password
    }
}

