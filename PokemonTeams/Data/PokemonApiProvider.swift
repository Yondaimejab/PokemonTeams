//
//  PokemonApiProvider.swift
//  PokemonTeams
//
//  Created by Joel Alcantara burgos on 28/2/21.
//

import Foundation
import Combine

class PokemonApiProvider: PokemonProviding {
    enum PokemonServiceError: Error {
        case invalidURL
        case couldNotEncodeParameters
    }

    static var shared = PokemonApiProvider()
    private let pokemonPublisher = PassthroughSubject<Pokemon, Error>()
    private var pokemonListSubscriber: AnyCancellable?
    private var pokemonSubscriberGroup = Set<AnyCancellable>()

    private func getPokemonsURL(limit: Int?, offset: Int?) -> AnyPublisher<[PokemonResponse], Error>  {
        let endPoint = EndPoints.pokemonList

        guard let url = URL(string: Routes.baseURL + endPoint.getEndPoint()) else {
            let publisher = Future<[PokemonResponse], Error> { promise in
                promise(.failure(PokemonServiceError.invalidURL))
            }

            return publisher.eraseToAnyPublisher()
        }


        let limitString = "\(20 * (limit != nil ? (limit! > 1 ? limit! : 1) : 1))"
        let offsetString = "\(20 * (offset != nil ? (offset! > 1 ? offset! : 1) : 1))"
        let requestWithQuery = url.appending("limit", value: limitString)
            .appending("offset", value: offsetString)

        
        return URLSession.shared.dataTaskPublisher(for: requestWithQuery)
            .map(\.data).compactMap({ (data: Data) -> Data? in

                if let dict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {

                    if let results = dict["results"] {
                        return try?JSONSerialization.data(withJSONObject: results, options: .prettyPrinted)
                    }

                }
                return nil

            })
            .decode(type: [PokemonResponse].self, decoder: JSONDecoder())
            .receive(on: RunLoop.main).eraseToAnyPublisher()
    }

    func getPokemons(limit: Int?, offset: Int?) -> AnyPublisher<[Pokemon], Error> {
        self.pokemonSubscriberGroup.removeAll()

        pokemonListSubscriber = self.getPokemonsURL(limit: limit, offset: offset)
            .sink(receiveCompletion: ({ _ in
            }), receiveValue: { (listOfResponse) in
                for item in listOfResponse {
                    self.getPokemon(with: item.url)
                        .sink(receiveCompletion: ({_ in })) { (pokemon) in
                        self.pokemonPublisher.send(pokemon)
                    }.store(in: &self.pokemonSubscriberGroup)
                }
            })

        let publisherLimit = (20 * (limit != nil ? (limit! > 1 ? limit! : 1) : 1))
        return pokemonPublisher.prefix(publisherLimit).collect().eraseToAnyPublisher()
    }

    func getPokemon(with url: String) -> AnyPublisher<Pokemon, Error>{
        guard let url = URL(string: url) else {
            let publisher = Future<Pokemon, Error> { promise in
                promise(.failure(PokemonServiceError.invalidURL))
            }

            return publisher.eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: url).map(\.data)
            .decode(type: Pokemon.self, decoder: JSONDecoder()).print()
            .receive(on: RunLoop.main).eraseToAnyPublisher()
    }

    func getPokemon(id: String?, name: String?) -> AnyPublisher<Pokemon, Error>  {
        let endPoint = EndPoints.pokemon(id: id, name: name)

        guard let url = URL(string: Routes.baseURL + endPoint.getEndPoint()) else {
            let publisher = Future<Pokemon, Error> { promise in
                promise(.failure(PokemonServiceError.invalidURL))
            }

            return publisher.eraseToAnyPublisher()
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = endPoint.getHttpMethod()

        return URLSession.shared.dataTaskPublisher(for: urlRequest).map(\.data)
            .decode(type: Pokemon.self, decoder: JSONDecoder())
            .receive(on: RunLoop.main).eraseToAnyPublisher()
    }
}
