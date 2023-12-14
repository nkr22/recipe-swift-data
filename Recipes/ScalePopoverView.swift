//
//  ScalePopoverView.swift
//  Recipes
//
//  Created by Noelia Root on 12/14/23.
//

import SwiftUI

struct ScalePopoverView: View {
    @Binding var scaleValue: Double

    var body: some View {
        // This is just a simple example; you can customize it as needed
        VStack {
            Text("Scale Ingredients")
                .font(.headline)

            Slider(value: $scaleValue, in: 0.5...3.0, step: 0.5)
            Text("Scale: \(scaleValue, specifier: "%.1f")x")
        }
        .padding()
    }
}
//#Preview {
//    ScalePopoverView()
//}
