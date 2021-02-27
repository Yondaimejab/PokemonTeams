//
//  RegisterResponses.swift
//  PokemonTeams
//
//  Created by Joel Alcantara burgos on 27/2/21.
//

import Foundation

protocol RegisterResponse {
    var success: Bool {get set}
    var message: String {get set}
}

class FailedRegisterResponse:  RegisterResponse {
    var success: Bool
    var message: String

    init(success: Bool, message: String) {
        self.success = success
        self.message = message
    }
}

class SuccessRegisterResponse: RegisterResponse {
    var success: Bool
    var message: String
    var user: User

    init(success: Bool, message: String, user: User) {
        self.success = success
        self.message = message
        self.user = user
    }
}
