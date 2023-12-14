//
//  DateFormatter+CustomDateFormatter.swift
//  Recipes
//
//  Created by Noelia Root on 12/14/23.
//

import SwiftUI
import Foundation

extension DateFormatter {
    static let myCustomFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return formatter
    }()
}
