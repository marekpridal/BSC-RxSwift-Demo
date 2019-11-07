//
//  AppDependencyInjectionContainer.swift
//  BSC
//
//  Created by Marek Přidal on 07/11/2019.
//  Copyright © 2019 Marek Pridal. All rights reserved.
//

import Foundation
import Swinject
import SwinjectAutoregistration
import SwinjectStoryboard

final class AppDependencyInjectionContainer {
    static let shared = AppDependencyInjectionContainer()

    var container = SwinjectStoryboard.defaultContainer

    private init() {
        register()
    }

    private func register() {
        container.register(Api.self, factory: { _ in Networking() })
//        container.register(Api.self, factory: { _ in MockNetworking() })

        container.autoregister(NotesViewModel.self, initializer: NotesViewModel.init)
        container.autoregister(NoteDetailViewModel.self, initializer: NoteDetailViewModel.init)

        container.register(NotesViewController.self) { r in
            let vc = NotesViewController(viewModel: r~>)
            return vc
        }
        container.register(NoteDetailViewController.self) { r in
            let vc = NoteDetailViewController(viewModel: r~>)
            return vc
        }
    }
}
