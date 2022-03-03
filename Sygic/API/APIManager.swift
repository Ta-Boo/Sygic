//
//  APIManager.swift
//  Sygic
//
//  Created by Tobiáš Hládek on 01/03/2022.
//

import Foundation
import Combine
import SwiftUI

struct Routing {
    private static let baseURL = "api.github.com/"
    static let usersQuerry = baseURL + "search/users"
    static func repository(login: String) -> String { baseURL + "users/\(login)/repos" }

}

class APIManager {
    enum ErrorType: Error {
        case wrongURL
        case emptyResponse
    }
    
    
    static func fetchData<T: Decodable>(
        from urlString: String,
        parameters: [URLQueryItem],
        completionClosure : @escaping (Result<T, Error>) -> Void
    ) {
        var components = URLComponents()
        components.scheme = "https"
        components.path = urlString
        components.queryItems = parameters
        guard let url = components.url else {
            completionClosure(.failure(ErrorType.wrongURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completionClosure(.failure(error))
                return
            }
            
            guard let data = data else {
                completionClosure(.failure(ErrorType.emptyResponse))
                return
            }
            
            do {
                let result = try JSONDecoder().decode(T.self, from: data)
                completionClosure(.success(result))
            } catch {
                completionClosure(.failure(error))
            }
            
        }.resume()
    }
    //can be static,
    static func getRequest<T: Decodable>(
        type: T.Type,
        url: String,
        parameters: [URLQueryItem]
    ) -> AnyPublisher<T, Error> {
            
            var components = URLComponents()
            components.scheme = "https"
            components.path = url
            components.queryItems = parameters
            guard let url = components.url else {
                preconditionFailure("Invalid URL")
            }

            return URLSession.shared.dataTaskPublisher(for: URLRequest(url: url))
                .map(\.data)
                .decode(type: T.self, decoder: JSONDecoder())
                .receive(on: RunLoop.main)
                .eraseToAnyPublisher()

                
        }
    
    static func downloadImage(url: String)  -> AnyPublisher<Data, URLSession.DataTaskPublisher.Failure>{
        
        guard let url = URL(string: url) else {
            preconditionFailure("Invalid URL")
        }

        return URLSession.shared.dataTaskPublisher(for: URLRequest(url: url))
            .map(\.data)
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
}
