//
//  NotesModelTests.swift
//  BSCTests
//
//  Created by Marek Pridal on 27.05.18.
//  Copyright © 2018 Marek Pridal. All rights reserved.
//

import XCTest
import RxSwift

@testable import BSC

final class NotesModelTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testMockDataConsistency() {
        let disposeBag = DisposeBag()
        let model = NotesViewModel()
        let expectation = XCTestExpectation(description: "Wait until notes are downloaded")
        model.notes.subscribe(onNext: { XCTAssert($0.count == 2, "Mock API returns invalid number of notes \($0.count)"); expectation.fulfill() }).disposed(by: disposeBag)
        model.refreshData()
        wait(for: [expectation], timeout: 10.0)
    }
}
