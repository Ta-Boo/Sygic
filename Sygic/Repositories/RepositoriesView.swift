//
//  ContentView.swift
//  Sygic
//
//  Created by Tobiáš Hládek on 01/03/2022.
//

import SwiftUI

struct RepositoriesView: View {
    @ObservedObject var viewModel: RepositoriesViewModel
    @State var presentedSheetData: PresentedView?

    private var gridItemLayout = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        GeometryReader{ geometry in
            ScrollView {
                LazyVGrid(
                    columns: [GridItem(.flexible())]) {
                        ForEach(viewModel.repositories, id: \.self) { repository in
                            RepositoryCell(data: repository, geometry: geometry)
                                .onAppear{
                                    if repository == viewModel.repositories.last {
                                        viewModel.fetchRepositories()
                                    }
                                }
                                .onTapGesture {
                                    presentedSheetData = .detail(repository)
                                }
                        }
                    }
                    .padding()
                
                if(viewModel.isLoading){
                    ProgressView()
                }
            }
        }
        .onAppear{
            viewModel.fetchRepositories()
        }
        .sheet(item: $presentedSheetData) { sheet in
            switch (sheet) {
            case .detail(let data):
                RepositoryDetailView(data: data, isPresented: $presentedSheetData)
            }
        }
    }
    
    init(viewModel: RepositoriesViewModel) {
        self.viewModel = viewModel
//        viewModel.fetchRepositories()
    }
}

