//
//  LoginViewModel.swift
//  PokemonTeams
//
//  Created by Joel Alcantara burgos on 27/2/21.
//

import Foundation
import Combine

class LoginViewModel {
    var authProvider: AuthProviding

    init(authProvider: AuthProviding = FirebaseAuthProvider.init()) {
        self.authProvider = authProvider
    }

    func login(user: String, password: String) -> Future<LoginResponse, Never> {
        let future = Future<LoginResponse, Never> { promise in
            self.authProvider.login(email: user, password: password) { (response) in
                promise(.success(response))
            }
        }
        return future
    }
}
