//
//  Pokemon.swift
//  PokemonTeams
//
//  Created by Joel Alcantara burgos on 27/2/21.
//

import Foundation

struct Pokemon: Hashable {
    var id: String
    var name: String
    var description: String
    var imageString: String

    var imageURL: URL? {
        get {
            return URL(string: imageString)
        }
    }

    init(name: String, description: String, imageString: String) {
        self.name = name
        self.description = description
        self.imageString = imageString
        self.id = UUID().uuidString
    }

    init(id: String, name: String, description: String, imageString: String) {
        self.name = name
        self.description = description
        self.imageString = imageString
        self.id = id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
