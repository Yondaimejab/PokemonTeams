//
//  LoginResponse.swift
//  PokemonTeams
//
//  Created by Joel Alcantara burgos on 27/2/21.
//

import Foundation

class LoginResponse {
    var success: Bool
    var message: String

    init(success: Bool, message: String) {
        self.success = success
        self.message = message
    }
}
