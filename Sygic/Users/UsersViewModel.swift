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
    let subject = PassthroughSubject<Int, Never>()



    
    func fetchUsers(append: Bool = false) {
        APIManager.getRequest(type: UsersModel.self,
                                     url: Routing.usersQuerry,
                                     parameters: [
                                        URLQueryItem(name: "q", value: querry),
                                        URLQueryItem(name: "page", value: "\(apiPage)"),
                                       ])
            .sink(
                receiveCompletion: { result in
                switch result {
                case let .failure(error):
                    print("Couldn't get users: \(error)")
                case .finished:
                    break
                }
            }, receiveValue: { users in
                guard let items = users.items else { return }
                if append {
                    self.users.append(contentsOf: items)
                } else {
                    self.users = items
                }
            }
            )
            .store(in: &cancellables)
    }
    

    
    init() {
        bind()
    }
    
    func bind() {
        $querry
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .sink(receiveValue:  { [weak self] value in
            if (value != "" && value == self?.querry) {
                self?.apiPage = 1
                self?.fetchUsers()
            }
        })
            .store(in: &cancellables)
    }
    
    func loadMoreUsers() {
        apiPage += 1
        fetchUsers(append: true)
    }
    
    deinit {
        print("Querry view disposed")
    }
}
