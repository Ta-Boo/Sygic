//
//  APIManager.swift
//  Sygic
//
//  Created by Tobiáš Hládek on 01/03/2022.
//

import Foundation

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
}
