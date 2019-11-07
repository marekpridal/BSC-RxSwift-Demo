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

    init(api: Api) {
        self.api = api
    }

    func update(note: Note) {
        api.update(note: note).subscribe(onNext: { _ in
            NotificationCenter.default.post(name: NSNotification.Name(Identifier.update), object: nil)
        }, onError: { [weak self] error in
            self?.errorHandler?(error)
        }).disposed(by: disposeBag)
    }

    func new(note: Note) {
        api.post(note: note).observeOn(MainScheduler.asyncInstance).subscribe(onNext: { [weak self] _ in
            NotificationCenter.default.post(name: NSNotification.Name(Identifier.update), object: nil)
            self?.delegate?.noteDetailDidFinish()
        }, onError: { [weak self] error in
            self?.delegate?.noteDetailDidFinish()
            self?.errorHandler?(error)
        }).disposed(by: disposeBag)
    }
}
