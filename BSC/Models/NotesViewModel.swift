//
//  NotesViewModel.swift
//  BSC
//
//  Created by Marek Pridal on 25.05.18.
//  Copyright © 2018 Marek Pridal. All rights reserved.
//

import Foundation
import RxSwift

class NotesViewModel {
    
    private let request = Networkig()
    let notes = BehaviorSubject<[NoteTO]>(value: [])
    let error = PublishSubject<Error>()
    private let disposeBag = DisposeBag()
    
    init() {
        refreshData()
        NotificationCenter.default.addObserver(forName: NSNotification.Name(identifier.update), object: nil, queue: nil) { [weak self] (_) in
            self?.refreshData()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func refreshData() {
        request.getNotes().observeOn(MainScheduler.asyncInstance).subscribe(onNext: { [weak self] (notes) in
            self?.notes.onNext(notes)
        }, onError: { [weak self] (error) in
            self?.error.onNext(error)
        }, onCompleted: { [weak self] in
            self?.notes.onCompleted()
            print("Completed")
        }).disposed(by: disposeBag)
        
    }
    
    func delete(note: NoteTO) {
        request.remove(note: note).subscribe(onNext: {
            [weak self] success in
            if success {
                guard var notes = (try? self?.notes.value()), let index = notes?.index(where: { $0.id == note.id }) else {
                    self?.refreshData()
                    return
                }
                notes?.remove(at: index)
                self?.notes.onNext(notes ?? [])
            }
        }, onError: { [weak self] (error) in
            self?.error.onNext(error)
        }).disposed(by: disposeBag)
    }
    
}
