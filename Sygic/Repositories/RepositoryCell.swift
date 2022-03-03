//
//  RepositoryCell.swift
//  Sygic
//
//  Created by Tobiáš Hládek on 02/03/2022.
//

import SwiftUI
import Combine


struct ColorPair{
    let start: Color
    let end: Color
}

struct RepositoryCell: View {
    let data: RepositoryModel
    let geometry: GeometryProxy
    let colorPairs = [
        ColorPair(start: .rgba(2, 195, 154), end: .rgba(2, 128, 144)),
        ColorPair(start: .rgba(2, 128, 144), end: .rgba(0, 168, 150)),
        ColorPair(start: .rgba(0, 168, 150), end: .rgba(2, 195, 154)),
    ]
    var body: some View {
        let size = geometry.size.width * 0.95
        let colorPair = colorPairs[(data.stars ?? 0) % colorPairs.count]
        VStack{
            HStack{
                VStack {
                    Text(data.fullName ?? "Unknown")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Spacer()
                }
                Spacer()
                VStack{
                    AsyncImage(
                        url: URL(string: data.owner.avatarURL)!,
                                    content: { image in
                                        image.resizable()
                                            .frame(width: size*0.3, height: size*0.3)
                                            .aspectRatio(contentMode: .fit)
                                            .clipShape(Circle())
                                            .background(.clear)
                                    },
                                    placeholder: {
                                        ProgressView()
                                            .frame(width: size*0.3, height: size*0.3)
                                    }
                                )
                    
//                    AsyncImageView(
//                        url: data.owner.avatarURL,
//                        placeholder: {
//                          ProgressView().frame(width: size*0.3, height: size*0.3)
//                        },
//                        image: {
//                          $0.resizable().frame(width: size*0.3, height: size*0.3).aspectRatio(contentMode: .fit).clipShape(Circle())
//                        }
//                      )
//                    )
                    HStack{
                        Image(systemName: "star.fill").foregroundColor(.white).padding(.vertical, 5)
                        Text("\(data.stars ?? 0)").font(.headline).foregroundColor(.white)
                    }
                }
            }
            .padding()
            Text(data.description ?? "Description is missing")
                .font(.body)
                .foregroundColor(.white)
                .lineLimit(2)
            Spacer()
        }
        .frame(width: size, height: size*0.75)
        .background(LinearGradient(gradient: Gradient(colors: [colorPair.start, colorPair.end]), startPoint: .top, endPoint: .bottom))
        .cornerRadius(10)
    }

  
}
