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
    private let api: Api
    private let storage: LocalStorage

    init(api: Api, storage: LocalStorage) {
        self.api = api
        self.storage = storage

        storage.notes.bind(to: notes).disposed(by: disposeBag)

        refreshData()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    func refreshData() {
        api.getNotes().catchError({ [weak self] error -> Observable<[Note]> in
            self?.error.onNext(error)
            return Observable.just([])
        }).bind(to: storage.notes).disposed(by: disposeBag)
    }

    func delete(note: Note) {
        api.remove(note: note).compactMap { [weak self] noteDeleted -> Note? in
            guard noteDeleted else {
                self?.error.onNext(GeneralError())
                return nil
            }
            return note
        }
        .subscribe(onNext: { [weak self] note in
            self?.storage.delete(note: note)
        })
        .disposed(by: disposeBag)
    }
}
