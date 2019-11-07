//
//  MockNetworking.swift
//  BSC
//
//  Created by Marek Přidal on 07/11/2019.
//  Copyright © 2019 Marek Pridal. All rights reserved.
//

import Foundation
import RxSwift

struct MockNetworking: Api {
    func getNotes() -> Observable<[Note]> {
        Observable.just([Note(id: 1, title: "Title 1"), Note(id: 2, title: "Title 2")])
    }

    func post(note: Note) -> Observable<Note> {
        Observable.just(note)
    }

    func update(note: Note) -> Observable<Note> {
        Observable.just(note)
    }

    func remove(note: Note) -> Observable<Bool> {
        Observable.just(true)
    }
}
