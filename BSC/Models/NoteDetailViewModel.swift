//
//  NoteDetailViewModel.swift
//  BSC
//
//  Created by Marek Pridal on 26.05.18.
//  Copyright © 2018 Marek Pridal. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class NoteDetailViewModel {
    let note = BehaviorRelay<NoteTO?>(value: nil)
    let error = PublishSubject<Error>()

    private let disposeBag = DisposeBag()
    private let api: Networkig

    init(api: Networkig = Networkig()) {
        self.api = api
    }

    func update(note: NoteTO) {
        api.update(note: note).subscribe(onNext: { (_) in
            NotificationCenter.default.post(name: NSNotification.Name(Identifier.update), object: nil)
        }, onError: { [weak self] (error) in
            self?.error.onNext(error)
        }).disposed(by: disposeBag)
    }

    func new(note: NoteTO) {
        api.post(note: note).subscribe(onNext: { (_) in
            NotificationCenter.default.post(name: NSNotification.Name(Identifier.update), object: nil)
        }, onError: { [weak self] (error) in
            self?.error.onNext(error)
        }).disposed(by: disposeBag)
    }
}
