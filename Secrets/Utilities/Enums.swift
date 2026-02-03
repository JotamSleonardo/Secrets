//
//  Enums.swift
//  Secrets
//
//  Created by Jotam Leonardo on 2/3/26.
//

import Foundation
import SwiftUI

enum Mode {
    case add
    case edit(VaultItemForm)

    var title: String { self.isAdd ? "New Secret" : "Edit Secret" }
    var isAdd: Bool {
        if case .add = self { return true }
        return false
    }
    var initial: VaultItemForm {
        switch self {
        case .add:
            return VaultItemForm()
        case .edit(let item):
            return item
        }
    }
}
