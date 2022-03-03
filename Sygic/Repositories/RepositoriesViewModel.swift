//
//  RepositoriesViewModel.swift
//  Sygic
//
//  Created by Tobiáš Hládek on 01/03/2022.
//

import Foundation
import SwiftUI

enum PresentedView: Identifiable {
    case detail(RepositoryModel)
    
    var id: Int {
        switch self {
        case .detail(_):
            return 0
        }
    }
}

class RepositoriesViewModel: ObservableObject {
    let login: String
    var apiPage = 1
    @Published var repositories = [RepositoryModel]()
    @Published var isLoading = false
    
    init(login: String) {
        self.login = login
    }
    
    func fetchRepositories() {
        isLoading = true
        APIManager.fetchData(from: Routing.repository(login: login),
                             parameters: [
//                                URLQueryItem(name: "q", value: querry),
                                URLQueryItem(name: "page", value: "\(apiPage)"),
                             ]) { [weak self] (result: Result<[RepositoryModel], Error>)  in
            guard let self = self else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
                self.isLoading = false
                switch result {
                case .success(let repositories):
                    self.repositories.append(contentsOf: repositories)
                    print(repositories.count)
                    self.apiPage += 1
                case .failure(let failure):
                    print(failure)
                }
            }
        }
    }
}
