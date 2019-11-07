//
//  ApplicationCoordinator.swift
//  BSC
//
//  Created by Marek Přidal on 07/11/2019.
//  Copyright © 2019 Marek Pridal. All rights reserved.
//

import Foundation
import RxSwift
import UIKit

final class ApplicationCoordinator {
    private let presenter: UINavigationController
    private let window: UIWindow
    private let disposeBag = DisposeBag()

    fileprivate init(window: UIWindow, navigationController: UINavigationController) {
        self.presenter = navigationController
        self.window = window
    }

    func start() {
        window.rootViewController = presenter
        window.makeKeyAndVisible()

        showNotes()
    }

    func showNotes() {
        let notes = NotesViewController.instantiate()
        notes.viewModel.delegate = self
        presenter.pushViewController(notes, animated: true)
    }

    static func startApplicationCoordinator(window: UIWindow) -> ApplicationCoordinator {
        let applicationCoordinator = ApplicationCoordinator(window: window, navigationController: UINavigationController())
        applicationCoordinator.start()
        return applicationCoordinator
    }
}

extension ApplicationCoordinator: NotesViewModelDelegate {
    func showNoteDetail(note: Note, errorHandler: @escaping (Error) -> Void) {
        let noteVC = NoteDetailViewController.instantiate()
        noteVC.viewModel.errorHandler = errorHandler
        noteVC.viewModel.delegate = self
        noteVC.viewModel.note.accept(note)
        presenter.pushViewController(noteVC, animated: true)
    }

    func showNewNoteForm(errorHandler: @escaping (Error) -> Void) {
        let noteVC = NoteDetailViewController.instantiate()
        noteVC.viewModel.delegate = self
        noteVC.viewModel.errorHandler = errorHandler
        noteVC.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save".localized, style: .done, target: nil, action: nil)
        noteVC.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel".localized, style: .plain, target: nil, action: nil)
        noteVC.navigationItem.leftBarButtonItem?.rx.tap.bind { noteVC.dismiss(animated: true, completion: nil) }.disposed(by: disposeBag)
        presenter.present(UINavigationController(rootViewController: noteVC), animated: true, completion: nil)
    }
}

extension ApplicationCoordinator: NoteDetailViewModelDelegate {
    func noteDetailDidFinish() {
        presenter.dismiss(animated: true, completion: nil)
    }
}
