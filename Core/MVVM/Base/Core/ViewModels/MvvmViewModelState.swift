//
//  MvvmViewModelState.swift
//  ReManga
//
//  Created by Даниил Виноградов on 09.11.2021.
//

import Foundation

struct MvvmError: Equatable, Error {
    let title: String
    let message: String?
    let retryCallback: (()->())?

    static func == (lhs: MvvmError, rhs: MvvmError) -> Bool {
        lhs.title == rhs.title && lhs.message == rhs.message
    }

    init(_ error: Error, retryCallback: (()->())?) {
        title = "Error"
        message = error.localizedDescription
        self.retryCallback = retryCallback
    }
}

enum MvvmViewModelState: Equatable {
    case done
    case processing
    case error(MvvmError)
}
