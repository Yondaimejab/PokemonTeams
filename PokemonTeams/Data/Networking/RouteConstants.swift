//
//  RouteConstants.swift
//  PokemonTeams
//
//  Created by Joel Alcantara burgos on 28/2/21.
//

import Foundation


enum Routes {
    static let baseURL = "https://pokeapi.co/api/v2/"
    static let pokemonEndPoint = "pokemon/22/"
}

enum EndPoints {
    case pokemon(id: String?, name: String?)
    case pokemonList

    func getEndPoint() -> String {
        switch self {
        case .pokemon(let id, let name):
            let searchTerm = id != nil ? id! : name ?? ""
            return "pokemon/\(searchTerm)"
        case .pokemonList:
            return "pokemon/"
        }
    }

    func getHttpMethod() -> String {
        switch self {
        case .pokemon, .pokemonList:
            return "GET"
        }
    }

    func getParameters() -> [String: Any]? {
        return nil
    }
}
