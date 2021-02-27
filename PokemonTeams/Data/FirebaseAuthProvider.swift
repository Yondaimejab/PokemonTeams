//
//  FirebaseAuthProvider.swift
//  PokemonTeams
//
//  Created by Joel Alcantara burgos on 27/2/21.
//

import Foundation
import Firebase

class FirebaseAuthProvider: AuthProviding {
    enum Constants {
        static let successLoginMessage = "Se ha iniciado seccion con exito.";
        static let successRegisterMessage = "Se ha creado su cuenta con exito.";
    }

    func login(email: String, password: String, completion: @escaping (LoginResponse) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            if let error = error {
                completion(LoginResponse(success: false, message: error.localizedDescription))
            } else {
                completion(LoginResponse(success: true, message: Constants.successLoginMessage))
            }
        }
    }

    func register(name: String, lastName: String, email: String, password: String, completion: @escaping (RegisterResponse) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            if let error = error {
                completion(FailedRegisterResponse(success: false, message: error.localizedDescription))
            } else {
                let firebaseDb = Firestore.firestore()

                firebaseDb.collection("Users").addDocument(
                    data: [
                        "Name": name,
                        "lastName": lastName,
                        "email": email,
                        "id": authResult?.user.uid ?? "1"
                    ]) { (error) in
                    if let error = error {
                        completion(FailedRegisterResponse(success: false, message: error.localizedDescription))
                    }
                }

                let user = User(id: authResult?.user.uid ?? "1", name: name, lastName: lastName, email: email)
                completion(SuccessRegisterResponse(success: true, message: Constants.successRegisterMessage, user: user))
            }
        }
    }


}
