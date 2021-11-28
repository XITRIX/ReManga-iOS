//
//  DateExtensions.swift
//  ReManga
//
//  Created by Даниил Виноградов on 29.11.2021.
//

import Foundation

extension Date {
    func timeAgo() -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: self, relativeTo: Date())
    }
}
