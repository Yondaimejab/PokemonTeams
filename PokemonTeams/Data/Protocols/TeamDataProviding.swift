//
//  FirestoreTeamDataProviding.swift
//  PokemonTeams
//
//  Created by Joel Alcantara burgos on 28/2/21.
//

import Foundation
import Combine

protocol TeamDataProviding {
    func create(team: FirestoreTeamRepresentation) -> AnyPublisher<Bool, Error>
    func update(team: FirestoreTeamRepresentation) -> AnyPublisher<Bool, Error>
    func listTeams(for userID: String) -> AnyPublisher<[FirestoreTeamRepresentation], Error>
    func delete(team id: String) -> AnyPublisher<Bool, Error>
}
