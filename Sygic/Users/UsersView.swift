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
                    TextField("Type to search...", text: $viewModel.querry)
                        .padding(7)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .padding()
                        .navigationTitle("Users").foregroundColor(.black)
                    LazyVStack {
                        ForEach(viewModel.users, id: \.self) { user in
                            if let login = user.login {
                                NavigationLink(login) {
                                    RepositoriesView(viewModel: RepositoriesViewModel(login: login))
                                }
                                .frame(height: 60, alignment: .leading)
                                .onAppear{
                                    if user == viewModel.users.last {
                                        viewModel.loadMoreUsers()
                                    }
                                }
                                
                            }
                        }
                    }
                }
                .resignKeyboardOnDragGesture()
            
            
            
            
        }
    }
    
    
    //    init() {
    //        viewModel.fetchUsers()
    //    }
}
struct ResignKeyboardOnDragGesture: ViewModifier {
    var gesture = DragGesture().onChanged{_ in
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    func body(content: Content) -> some View {
        content.gesture(gesture)
    }
}

