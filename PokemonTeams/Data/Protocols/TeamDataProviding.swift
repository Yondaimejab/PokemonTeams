//
//  FirestoreTeamDataProviding.swift
//  PokemonTeams
//
//  Created by Joel Alcantara burgos on 28/2/21.
//

import Foundation
import Combine

protocol TeamDataProviding {
    func create(team: Team) -> AnyPublisher<Bool, Error>
    func update(team: Team) -> AnyPublisher<Bool, Error>
    func listTeams(for user: User) -> AnyPublisher<[Team], Error>
    func delete(team id: String) -> AnyPublisher<Bool, Error>
}
