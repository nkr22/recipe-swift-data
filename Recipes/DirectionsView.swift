//
//  DirectionsView.swift
//  Recipes
//
//  Created by Noelia Root on 12/14/23.
//

import SwiftUI

struct DirectionsView: View {
    var directions: [Direction]
    var sortedDirections: [Direction] {
        directions.sorted(by: {$0.order < $1.order})
    }

    var body: some View {
        ForEach(sortedDirections) {direction in
            Text("\(direction.order). \(direction.direction)")
                .font(.subheadline)
        }
    }
}

//#Preview {
//    DirectionsView()
//}
