//
//  UserProvider.swift
//  RandomUserKit
//
//  Created by Romain Pouclet on 2017-11-21.
//  Copyright © 2017 Buddybuild. All rights reserved.
//

import Foundation

public struct Response<T: Decodable & Equatable>: Decodable, Equatable {
    let results: [T]

    public static func ==(lhs: Response<T>, rhs: Response<T>) -> Bool {
        return lhs.results == rhs.results
    }
}

public struct User: Decodable {

    public struct Name: Decodable {
        public let first: String
        public let last: String
    }

    public let name: Name
    public let email: String
}

extension User.Name: Equatable {
    public static func ==(lhs: User.Name, rhs: User.Name) -> Bool {
        return lhs.first == rhs.first && lhs.last == rhs.last
    }

}
extension User: Equatable {
    public static func ==(lhs: User, rhs: User) -> Bool {
        return lhs.name == rhs.name && lhs.email == rhs.email
    }
}

public enum Result<T, E: Error> {
    case success(T)
    case failure(E)
}

final public class UserProvider {
    public enum ProviderError: Error {
        case networkError(Error)
        case noResult
        case decodingError(Error)
    }

    public func fetchOne(completion: @escaping (Result<User, ProviderError>) -> Void) -> URLSessionTask {
        let request = URLRequest(url: URL(string: "https://randomuser.me/api/?results=1")!)
        let task = URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                completion(.failure(.networkError(error)))
                return
            }

            guard let data = data else {
                completion(.failure(.noResult))
                return
            }

            let decoder = JSONDecoder()
            do {
                let response = try decoder.decode(Response<User>.self, from: data)
                if let user = response.results.first {
                    completion(.success(user))
                } else {
                    completion(.failure(.noResult))
                }
            } catch let error {
                completion(.failure(.decodingError(error)))
            }
        }

        task.resume()
        
        return task
    }
}
