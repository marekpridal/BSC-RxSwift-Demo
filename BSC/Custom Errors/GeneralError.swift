//
//  GeneralError.swift
//  BSC
//
//  Created by Marek Přidal on 07/11/2019.
//  Copyright © 2019 Marek Pridal. All rights reserved.
//

import Foundation

struct GeneralError: LocalizedError {
    var errorDescription: String? {
        "GENERAL_ERROR".localized
    }
}
