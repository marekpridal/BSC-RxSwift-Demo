//
//  NoteDetailViewModel.swift
//  BSC
//
//  Created by Marek Pridal on 26.05.18.
//  Copyright © 2018 Marek Pridal. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

protocol NoteDetailViewModelDelegate: class {
    func noteDetailDidFinish()
}

final class NoteDetailViewModel {
    let note = BehaviorRelay<Note?>(value: nil)
    var errorHandler: ((Error) -> Void)?

    weak var delegate: NoteDetailViewModelDelegate?

    private let disposeBag = DisposeBag()
    private let api: Api
    private let storage: LocalStorage

    init(api: Api, storage: LocalStorage) {
        self.api = api
        self.storage = storage
    }

    func update(note: Note) {
        api.update(note: note).subscribe(onNext: { [weak self] note in
            print("Note updated \(note)")
            self?.storage.update(note: note)
        }, onError: { [weak self] error in
            self?.errorHandler?(error)
        }).disposed(by: disposeBag)
    }

    func new(note: Note) {
        api.post(note: note).observeOn(MainScheduler.asyncInstance).subscribe(onNext: { [weak self] note in
            print("New note created \(note)")
            self?.storage.add(note: note)
            self?.delegate?.noteDetailDidFinish()
        }, onError: { [weak self] error in
            self?.delegate?.noteDetailDidFinish()
            self?.errorHandler?(error)
        }).disposed(by: disposeBag)
    }
}
