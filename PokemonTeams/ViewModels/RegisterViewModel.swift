//
//  RegisterViewModel.swift
//  PokemonTeams
//
//  Created by Joel Alcantara burgos on 27/2/21.
//

import Foundation
import Combine

class RegisterViewModel {
    private var authProvider: AuthProviding

    init(authProvider: AuthProviding = FirebaseAuthProvider.init()) {
        self.authProvider = authProvider
    }

    func registerUser(name: String, lastName: String, email: String, password: String) -> Future<RegisterResponse, Never> {
        let future = Future<RegisterResponse, Never> { [weak self] promise in
            self?.authProvider.register(name: name, lastName: lastName, email: email, password: password) { (registerResponse) in
                promise(.success(registerResponse))
            }
        }

        return future
    }
}
