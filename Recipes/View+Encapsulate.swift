//
//  View+Encapsulate.swift
//  Recipes
//
//  Created by Noelia Root on 12/12/23.
//

import Foundation
import SwiftUI

extension View {
    func encapsulate(color: Color, foregroundColor: Color = .black) -> some View {
        return self
            .padding(7)
            .padding(.horizontal, 5)
            .background(
                Capsule()
                    .fill(color)
            )
            .foregroundStyle(foregroundColor)
    }
}
