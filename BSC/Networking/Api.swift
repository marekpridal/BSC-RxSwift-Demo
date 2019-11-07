//
//  Api.swift
//  BSC
//
//  Created by Marek Přidal on 07/11/2019.
//  Copyright © 2019 Marek Pridal. All rights reserved.
//

import Foundation
import RxSwift

protocol Api {
    func getNotes() -> Observable<[Note]>
    func post(note: Note) -> Observable<Note>
    func update(note: Note) -> Observable<Note>
    func remove(note: Note) -> Observable<Bool>
}
