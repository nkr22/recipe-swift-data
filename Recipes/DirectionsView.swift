//
//  DirectionsView.swift
//  Recipes
//
//  Created by Noelia Root on 12/14/23.
//

import SwiftUI

struct DirectionsView: View {
    var directions: [Direction]

    var body: some View {
        List(directions.sorted { $0.order < $1.order }, id: \.self) { direction in
            Text("\(direction.order). \(direction.direction)")
                .font(.subheadline)
        }
    }
}

//#Preview {
//    DirectionsView()
//}
