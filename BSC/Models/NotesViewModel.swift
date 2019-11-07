//
//  NotesViewModel.swift
//  BSC
//
//  Created by Marek Pridal on 25.05.18.
//  Copyright © 2018 Marek Pridal. All rights reserved.
//

import Foundation
import RxRelay
import RxSwift

protocol NotesViewModelDelegate: class {
    func showNoteDetail(note: Note, errorHandler: @escaping (Error) -> Void)
    func showNewNoteForm(errorHandler: @escaping (Error) -> Void)
}

final class NotesViewModel {
    let notes = BehaviorRelay<[Note]>(value: [])
    let error = PublishSubject<Error>()

    weak var delegate: NotesViewModelDelegate?

    private let disposeBag = DisposeBag()
    private let api: Networking

    init(api: Networking = Networking()) {
        self.api = api

        refreshData()
        NotificationCenter.default.rx.notification(Notification.Name.init(Identifier.update)).subscribe { [weak self] _ in
            self?.refreshData()
        }
        .disposed(by: disposeBag)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    func refreshData() {
        api.getNotes().catchError({ [weak self] error -> Observable<[Note]> in
            self?.error.onNext(error)
            return Observable.just([])
        }).bind(to: notes).disposed(by: disposeBag)
    }

    func delete(note: Note) {
        api.remove(note: note).compactMap { [weak self] noteDeleted -> [Note]? in
            guard noteDeleted else {
                self?.error.onNext(GeneralError())
                return nil
            }
            var notes = self?.notes.value
            notes?.removeAll(where: { $0.id == note.id })
            return notes
        }
        .bind(to: notes)
        .disposed(by: disposeBag)
    }
}
