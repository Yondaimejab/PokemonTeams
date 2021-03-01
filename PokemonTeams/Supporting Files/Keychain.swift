//
//  Keychain.swift
//  PokemonTeams
//
//  Created by Joel Alcantara burgos on 28/2/21.
//

import Foundation

class Keychain {
    enum Constants {
        static let userKey = "savedUser"
    }

    private var userDefaults = UserDefaults.standard
    private var encoder = JSONEncoder.init()
    private var decoder = JSONDecoder.init()

    func saveValues<T: Codable>(with data: [String: T]) {
        for (key, value) in data {
            if let encodedValue = try? encoder.encode(value) {
                userDefaults.setValue(encodedValue, forKey: key)
            }
        }
    }

    func getData(for key: String) -> Data? {
        if let data = userDefaults.value(forKey: key) as? Data {
            return data
        }
        return nil
    }

    func logOut() {
        userDefaults.removeObject(forKey: Constants.userKey)
    }
}
