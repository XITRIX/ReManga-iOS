//
//  StringExtensions.swift
//  REManga
//
//  Created by Daniil Vinogradov on 21.02.2021.
//

import Foundation

extension Optional where Wrapped == String {
    var text: String {
        guard let res = self else {
            return ""
        }
        return res
    }
}

extension Optional where Wrapped == Int {
    var text: String {
        guard let res = self else {
            return ""
        }
        return "\(res)"
    }
}
