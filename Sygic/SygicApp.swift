//
//  SygicApp.swift
//  Sygic
//
//  Created by Tobiáš Hládek on 01/03/2022.
//

import SwiftUI
import Swinject
@main
struct SygicApp: App {
    let assembler = ExtendedAssembler()
    var body: some Scene {
        WindowGroup {
            UsersView()
        }
    }
    init() {
        assembler.assemble(container: Resolver.shared.container)
    }
}

class Resolver {
    static let shared = Resolver()
    let container: Container
    private init() {
        container = Container()
    }
    
    static func resolve<T>(_ type: T.Type) -> T {
        shared.container.resolve(T.self)!
    }
}

class ExtendedAssembler: Assembly {
    func assemble(container: Container) {
        container.register(APIManager.self) { resolver in
            APIManager()
        }.inObjectScope(.container)
    }
    
}
