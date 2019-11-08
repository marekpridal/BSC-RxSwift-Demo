//
//  NotesModelTests.swift
//  BSCTests
//
//  Created by Marek Pridal on 27.05.18.
//  Copyright © 2018 Marek Pridal. All rights reserved.
//

import RxSwift
import XCTest

@testable import BSC

final class NotesModelTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testAddNewNote() {
        let notesViewModel = NotesViewModel(api: MockNetworking(), storage: LocalStorage.shared)
        let originalCountOfNotes = notesViewModel.notes.value

        LocalStorage.shared.add(note: Note(id: 20, title: "Unit test"))

        XCTAssertEqual(originalCountOfNotes.count + 1, notesViewModel.notes.value.count)
    }
}
