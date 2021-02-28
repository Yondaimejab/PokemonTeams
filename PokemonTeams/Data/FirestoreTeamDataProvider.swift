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
    static var shared = FirestoreTeamDataProvider()

    func create(team: Team) -> AnyPublisher<Bool, Error> {
        // TODO
        return Future<Bool, Error> { promise in
            promise(.success(true))
        }.eraseToAnyPublisher()
    }

    func update(team: Team) -> AnyPublisher<Bool, Error> {
        // TODO
        return Future<Bool, Error> { promise in
            promise(.success(true))
        }.eraseToAnyPublisher()
    }

    func listTeams(for user: User) -> AnyPublisher<[Team], Error> {
        // TODO
        let publisher = Future<[Team], Error> { promise in
            promise(
                .success(
                    [try! Team(id: "adsa", name: "namasd", pokemons: [
                                Pokemon(id: "asd", name: "namasn",
                                        sprites: Sprite(front: "asdad", back: "Asdasd"),
                                        types: [PokemonType(slot: 1, type: Type(name: "asdads", url: "asdasddsa"))]
                                )],
                               user: User(id: "asd", name: "asdasd", lastName: "asdads", email: "asdads", password: "asdasdasdasddsa"))
                    ])
        )}

        return publisher.eraseToAnyPublisher()
    }

    func delete(team id: String) -> AnyPublisher<Bool, Error> {
        // TODO
        return Future<Bool, Error> { promise in
            promise(.success(true))
        }.eraseToAnyPublisher()
    }
}
