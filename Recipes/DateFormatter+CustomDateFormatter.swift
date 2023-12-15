//
//  DateFormatter+CustomDateFormatter.swift
//  Recipes
//
//  Created by Noelia Root on 12/14/23.
//  I asked ChatGPT "Can you make me a Swift extension to convert a string in this format "yyyy-MM-dd'T'HH:mm:ssZ" into a date?

import SwiftUI
import Foundation

extension DateFormatter {
    static let myCustomFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return formatter
    }()
}
