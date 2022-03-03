//
//  UsersViewModel.swift
//  Sygic
//
//  Created by Tobiáš Hládek on 02/03/2022.
//

import SwiftUI
import Combine


class UsersViewModel: ObservableObject {
    var apiPage = 1
    @Published var users = [UserModel]()
    @Published var querry = ""
    @Published var isLoading = false
    private var cancellables: Set<AnyCancellable> = []


    
    func fetchUsers() {
        isLoading = true
        APIManager.fetchData(from: Routing.usersQuerry,
                             parameters: [
                                URLQueryItem(name: "q", value: querry),
                                URLQueryItem(name: "page", value: "\(apiPage)"),
                             ]) { [weak self] (result: Result<UsersModel, Error>)  in
            guard let self = self else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
                self.isLoading = false
                switch result {
                case .success(let users):
                    guard let items = users.items else { return }
                    self.users = items
                    self.apiPage = 1
                case .failure(let failure):
                    print(failure)
                }
            }
        }
    }
    
    init() {
        bind()
    }
    
    func bind() {
        $querry
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .sink(receiveValue:  { [weak self] value in
            if (value != "" && value == self?.querry) {
                self?.fetchUsers()
            }
        })
            .store(in: &cancellables)
    }
    
    deinit {
        print("Querry view disposed")
    }
}
