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

class NoteDetailViewModel {
    
    let note = BehaviorSubject<NoteTO?>(value: nil)
    let error = PublishSubject<Error>()
    private let disposeBag = DisposeBag()
    private let request = Networkig()
    
    func update(note: NoteTO) {
        request.update(note: note).subscribe(onNext: { (_) in
            NotificationCenter.default.post(name: NSNotification.Name(identifier.update), object: nil)
        }, onError: { [weak self] (error) in
            self?.error.onNext(error)
        }).disposed(by: disposeBag)
    }
    
    func new(note: NoteTO) {
        request.post(note: note).subscribe(onNext: { (_) in
            NotificationCenter.default.post(name: NSNotification.Name(identifier.update), object: nil)
        }, onError: { [weak self] (error) in
            self?.error.onNext(error)
        }).disposed(by: disposeBag)
    }
    
}
