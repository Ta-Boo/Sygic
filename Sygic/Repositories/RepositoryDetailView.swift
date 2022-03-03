//
//  RepositoryDetailView.swift
//  Sygic
//
//  Created by Tobiáš Hládek on 02/03/2022.
//

import SwiftUI
import WebKit

struct RepositoryDetailView: View {

    let data: RepositoryModel
    @Binding var isPresented: PresentedView?
    var body: some View {
        if let urlAddress = data.htmlURL,
           let url = URL(string: urlAddress) {
            ZStack {
                WebView(request: URLRequest(url: url))
                HStack{
                    Spacer()
                    VStack {
                        Spacer()
                        Button{
                            isPresented = .none
                        } label: {
                            Image(systemName: "chevron.down.circle.fill")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .scaledToFit()
                        }
                        .padding()
                    }
                }
            }
        } else {
            HStack {
                Spacer()
                VStack {
                    Spacer()
                    Text("Url is missing or incorrect.")
                    Spacer()
                }
                Spacer()
            }
        }
    }
}

struct WebView : UIViewRepresentable {
    
    let request: URLRequest
    
    func makeUIView(context: Context) -> WKWebView  {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.load(request)
    }
    
}

