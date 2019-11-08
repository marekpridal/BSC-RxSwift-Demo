//
//  LocalStorage.swift
//  BSC
//
//  Created by Marek Přidal on 08/11/2019.
//  Copyright © 2019 Marek Pridal. All rights reserved.
//

import Foundation
import RxRelay

struct LocalStorage {
    let notes = BehaviorRelay<[Note]>(value: [])

    static let shared: LocalStorage = .init()

    private init() { }

    func update(note: Note) {
        var notes = self.notes.value
        guard let noteToUpdateIndex = notes.firstIndex(where: { $0.id == note.id }) else {
            add(note: note)
            return
        }
        notes.remove(at: noteToUpdateIndex)
        notes.insert(note, at: noteToUpdateIndex)
        self.notes.accept(notes)
    }

    func add(note: Note) {
        var notes = self.notes.value
        notes.append(note)
        self.notes.accept(notes)
    }

    func delete(note: Note) {
        let notes = self.notes.value.filter { $0.id != note.id }
        self.notes.accept(notes)
    }
}
