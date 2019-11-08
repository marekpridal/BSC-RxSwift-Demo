//
//  Note.swift
//  BSC
//
//  Created by Marek Pridal on 25.05.18.
//  Copyright © 2018 Marek Pridal. All rights reserved.
//

import Foundation

struct Note: Codable, Equatable {
    let id: Int?
    let title: String

    func changeTitle(newTitle: String) -> Note {
        return Note(id: id, title: newTitle)
    }
}
