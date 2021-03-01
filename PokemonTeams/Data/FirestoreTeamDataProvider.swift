//
//  FirestoreTeamDataProvideder.swift
//  PokemonTeams
//
//  Created by Joel Alcantara burgos on 28/2/21.
//

import Foundation
import Firebase
import Combine

class FirestoreTeamDataProvider: TeamDataProviding {

    enum FirestoreTeamError: Error {
        case gettingDocuments(String)
        case noSuitablePath
    }

    static var shared = FirestoreTeamDataProvider()
    let firebaseDb = Firestore.firestore()

    func create(team: FirestoreTeamRepresentation) -> AnyPublisher<Bool, Error> {
        return Future<Bool, Error> {[weak self] promise in
            self?.firebaseDb.collection("Teams").addDocument(data: team.data) { error in
                if let error = error {
                    print(error.localizedDescription)
                    promise(.failure(FirestoreTeamError.gettingDocuments(error.localizedDescription)))
                }else {
                    promise(.success(true))
                }
            }
        }.eraseToAnyPublisher()
    }

    func update(team: FirestoreTeamRepresentation) -> AnyPublisher<Bool, Error> {
        return Future<Bool, Error> { [weak self] promise in
            self?.firebaseDb.collection("Teams").getDocuments { (snapshot, error) in
                if let error = error {
                    print(error.localizedDescription)
                    promise(.failure(FirestoreTeamError.gettingDocuments(error.localizedDescription)))
                } else if let querySnapshot = snapshot {
                    let document = querySnapshot.documents.first(where: { (document) -> Bool in
                        document.documentID == team.id
                    })
                    document?.reference.updateData(team.data)
                    promise(.success(true))
                }
                promise(.failure(FirestoreTeamError.noSuitablePath))
            }
        }.eraseToAnyPublisher()
    }

    func listTeams(for userID: String) -> AnyPublisher<[FirestoreTeamRepresentation], Error> {
        let publisher = Future<[FirestoreTeamRepresentation], Error> { [weak self] promise in
            self?.firebaseDb.collection("Teams").getDocuments { (snapshot, error) in
                if let error = error {
                    print(error.localizedDescription)
                    promise(.failure(FirestoreTeamError.gettingDocuments(error.localizedDescription)))
                } else if let querySnapshot = snapshot {
                    let teamList = querySnapshot.documents.filter { (document) -> Bool in
                        let documentUserID = document.get("userID") as! String
                        return documentUserID == userID
                    }

                    let teamListFirestoreTeam: [FirestoreTeamRepresentation] = teamList.map { (document) -> FirestoreTeamRepresentation in
                        let ids = document.get("pokemonIDs") as? [String]
                        return FirestoreTeamRepresentation(id: document.documentID , name: document.get("name") as! String, userID: document.get("userID") as! String, pokemonIDs: ids!)
                    }

                    promise(.success(teamListFirestoreTeam))
                }

                promise(.failure(FirestoreTeamError.noSuitablePath))
            }
        }

        return publisher.eraseToAnyPublisher()
    }

    func delete(team id: String) -> AnyPublisher<Bool, Error> {
        return Future<Bool, Error> {[weak self] promise in
            self?.firebaseDb.collection("Teams").getDocuments(completion: { (snapshot, error) in
                if let error = error {
                    print(error.localizedDescription)
                    promise(.failure(FirestoreTeamError.gettingDocuments(error.localizedDescription)))
                } else if let querySnapshot = snapshot {
                    let teamItem = querySnapshot.documents.first { (document) -> Bool in
                        let documentUserID = document.documentID
                        return documentUserID == id
                    }
                    teamItem?.reference.delete()
                    promise(.success(true))
                }
                promise(.failure(FirestoreTeamError.noSuitablePath))
            })
        }.eraseToAnyPublisher()
    }
}
