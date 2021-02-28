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
                completion(FailLoginResponse(success: false, message: error.localizedDescription))
            } else {
                let firebaseDb = Firestore.firestore()
                firebaseDb.collection("Users").getDocuments { (query, error) in
                    if let error = error {
                        completion(FailLoginResponse(success: false, message: error.localizedDescription))
                    } else {
                        let userDocument = query?.documents.first { ($0.get("id") as! String) == authResult!.user.uid }
                        let id = userDocument?.get("id") as! String
                        let name = userDocument?.get("Name") as! String
                        let lastName = userDocument?.get("lastName") as! String
                        let user = User(id: id, name: name, lastName: lastName, email: email, password: password)
                        completion(SuccessLoginResponse(success: true, message: Constants.successLoginMessage, user: user))
                    }
                }
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

                let user = User(id: authResult?.user.uid ?? "1", name: name, lastName: lastName, email: email, password: password)
                completion(SuccessRegisterResponse(success: true, message: Constants.successRegisterMessage, user: user))
            }
        }
    }


}
