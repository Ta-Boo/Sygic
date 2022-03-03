//
//  UsersView.swift
//  Sygic
//
//  Created by Tobiáš Hládek on 02/03/2022.
//

import SwiftUI

struct UsersView: View {
    @ObservedObject var viewModel = UsersViewModel()
    var body: some View {
        NavigationView {
                //            LazyVGrid(
                //                columns: [GridItem(.flexible())]) {
                ScrollView {
                    TextField("Search", text: $viewModel.querry)
                        .padding(7)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .padding()
                        .navigationTitle("Users").foregroundColor(.black)
                    VStack {
                        ForEach(viewModel.users, id: \.self) { user in
                            if let login = user.login {
                                NavigationLink(login) {
                                    RepositoriesView(viewModel: RepositoriesViewModel(login: login))
                                }
                                .frame(height: 60, alignment: .leading)
                                
                            }
                            let _ = print(user.login)
                        }
                    }
//                    .background(.red)
                }
            
            
            
            
        }
    }
    
    
    //    init() {
    //        viewModel.fetchUsers()
    //    }
}

struct UsersView_Previews: PreviewProvider {
    static var previews: some View {
        UsersView()
    }
}
