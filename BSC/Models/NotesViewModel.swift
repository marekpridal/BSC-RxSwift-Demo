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

final class NotesViewModel {
    let notes = BehaviorRelay<[NoteTO]>(value: [])
    let error = PublishSubject<Error>()

    private let disposeBag = DisposeBag()
    private let api: Networkig

    init(api: Networkig = Networkig()) {
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
        api.getNotes().catchError({ [weak self] error -> Observable<[NoteTO]> in
            self?.error.onNext(error)
            return Observable.just([])
        }).bind(to: notes).disposed(by: disposeBag)
    }

    func delete(note: NoteTO) {
        api.remove(note: note).compactMap { [weak self] noteDeleted -> [NoteTO]? in
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
