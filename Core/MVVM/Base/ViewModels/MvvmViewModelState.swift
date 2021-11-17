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

//    static func == (lhs: MvvmViewModelState, rhs: MvvmViewModelState) -> Bool {
//        switch (lhs, rhs) {
//        case (.done, .done):
//            return true
//        case (.processing, .processing):
//            return true
//        case (.error(let err1), .error(let err2)):
//            return err1.localizedDescription == err2.localizedDescription
//        default:
//            return false
//        }
//    }
}
