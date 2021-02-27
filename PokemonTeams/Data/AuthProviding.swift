//
//  AuthProviding.swift
//  PokemonTeams
//
//  Created by Joel Alcantara burgos on 27/2/21.
//

import Foundation

protocol AuthProviding {
    func login(email: String, password: String, completion: @escaping (LoginResponse) -> Void)
    func register(name: String, lastName: String, email: String, password: String, completion: @escaping (RegisterResponse) -> Void)
}
