//
//  Pokemon.swift
//  PokemonTeams
//
//  Created by Joel Alcantara burgos on 27/2/21.
//

import Foundation

struct PokemonResponse: Codable {
    var name: String
    var url: String
}

struct Pokemon: Hashable, Codable {
    var id: String?
    var name: String
    var sprites: Sprite
    var types: [PokemonType]

    var imageUrl: URL? {
        if let frontUrl = URL(string: sprites.frontImageUrl ?? "") {
            return frontUrl
        } else if let backUrl = URL(string: sprites.backImageURL ?? "") {
            return backUrl

        }
        return nil
    }

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case sprites
        case types
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let pokemonName = try container.decode(String.self, forKey: .name)
        let pokemonSprites = try container.decode(Sprite.self, forKey: .sprites)
        let pokemonTypes = try container.decode([PokemonType].self, forKey: .types)

        self.id = "\(try container.decode(Int.self, forKey: .id))"
        self.name = pokemonName
        self.sprites = pokemonSprites
        self.types = pokemonTypes
    }

    init(id: String, name: String, sprites: Sprite, types: [PokemonType]) {
        self.id = id
        self.name = name
        self.sprites = sprites
        self.types = types
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: Pokemon, rhs: Pokemon) -> Bool {
       return lhs.id == rhs.id
    }
}

class Sprite: Codable {
    var frontImageUrl: String?
    var backImageURL: String?

    enum CodingKeys: String, CodingKey {
        case frontImageUrl = "front_default"
        case backImageURL = "back_default"
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let backImage = try? container.decode(String.self, forKey: .backImageURL)
        let frontImage = try? container.decode(String.self, forKey: .frontImageUrl)
        self.frontImageUrl = frontImage
        self.backImageURL = backImage
    }

    init(front: String, back: String) {
        self.backImageURL = front
        self.frontImageUrl = back
    }
}

class PokemonType: Codable {
    var slot: Int
    var type: Type

    init(slot: Int, type: Type) {
        self.slot = slot
        self.type = type
    }
}

class Type: Codable {
    var name: String
    var url: String

    init(name: String, url: String) {
        self.name = name
        self.url = url
    }
}
